@addField(SettingsMainGameController)
let modReference: SettingsCategory;

@addField(SettingsMainGameController)
let categoryReference: SettingsCategory;

public class ModStngsMainGameController extends gameuiSettingsMenuGameController {

  private let m_scrollPanel: inkWidgetRef;
  private let m_selectorWidget: inkWidgetRef;
  private let m_buttonHintsManagerRef: inkWidgetRef;
  private let m_settingsOptionsList: inkCompoundRef;
  private let m_applyButton: inkWidgetRef;
  private let m_resetButton: inkWidgetRef;
  private let m_defaultButton: inkWidgetRef;
  private let m_brightnessButton: inkWidgetRef;
  private let m_hdrButton: inkWidgetRef;
  private let m_controllerButton: inkWidgetRef;
  private let m_benchmarkButton: inkWidgetRef;
  private let m_descriptionText: inkTextRef;
  private let m_previousButtonHint: inkWidgetRef;
  private let m_nextButtonHint: inkWidgetRef;
  private let m_languageInstallProgressBarRoot: inkWidgetRef;
  
  private let m_languageInstallProgressBar: wref<SettingsLanguageInstallProgressBar>;
  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;
  private let m_settingsElements: array<wref<SettingsSelectorController>>;
  private let m_buttonHintsController: wref<ButtonHints>;
  private let m_data: array<SettingsCategory>;
  private let m_menusList: array<CName>;
  private let m_eventsList: array<CName>;
  private let m_settingsListener: ref<ModSettingsVarListener>;
  private let m_settingsNotificationListener: ref<ModSettingsNotificationListener>;
  private let m_settings: ref<UserSettings>;
  private let m_isPreGame: Bool;
  private let m_benchmarkNotificationToken: ref<inkGameNotificationToken>;
  private let m_isKeybindingAlertEnabled: Bool;
  private let m_applyButtonEnabled: Bool;
  private let m_resetButtonEnabled: Bool;
  private let m_closeSettingsRequest: Bool;
  private let m_resetSettingsRequest: Bool;
  private let m_isDlcSettings: Bool;
  private let m_selectorCtrl: wref<ListController>;


  protected cb func OnInitialize() -> Void {
    ModSettings.GetInstance().isActive = true;
    inkWidgetRef.SetVisible(this.m_hdrButton, false);
    inkWidgetRef.SetVisible(this.m_controllerButton, false);
    inkWidgetRef.SetVisible(this.m_brightnessButton, false);
    inkWidgetRef.SetVisible(this.m_benchmarkButton, false);

    this.m_settings = this.GetSystemRequestsHandler().GetUserSettings();
    this.m_isPreGame = this.GetSystemRequestsHandler().IsPreGame();

    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnButtonRelease");
    inkWidgetRef.GetControllerByType(this.m_applyButton, n"inkButtonController").RegisterToCallback(n"OnButtonClick", this, n"OnApplyButtonReleased");
    inkWidgetRef.GetControllerByType(this.m_resetButton, n"inkButtonController").RegisterToCallback(n"OnButtonClick", this, n"OnResetButtonReleased");
    inkWidgetRef.GetControllerByType(this.m_controllerButton, n"inkButtonController").RegisterToCallback(n"OnButtonClick", this, n"OnControllerButtonReleased");
    inkWidgetRef.GetControllerByType(this.m_defaultButton, n"inkButtonController").RegisterToCallback(n"OnButtonClick", this, n"OnDefaultButtonReleased");
    this.m_selectorCtrl = inkWidgetRef.GetController(this.m_selectorWidget) as ListController;
    this.m_selectorCtrl.RegisterToCallback(n"OnItemActivated", this, n"OnMenuChanged");
    this.m_buttonHintsController = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsManagerRef), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
    this.PopulateHints();
    this.PopulateSettingsData();

    this.PopulateCategories(0);
    this.CheckButtons();
    this.PlayLibraryAnimation(n"intro");
    this.m_closeSettingsRequest = false;
    this.m_resetSettingsRequest = false;

    ModSettings.RegisterListenerToModifications(this);
  }


  public func OnModSettingsChange() -> Void {
    this.CheckButtons();
    this.PopulateSettingsData();
    this.PopulateCategorySettingsOptions(-1);
    this.RefreshInputIcons();
  }


  protected cb func OnSetUserData(userData: ref<IScriptable>) -> Bool {
    let settingsUserData: ref<SettingsMenuUserData> = userData as SettingsMenuUserData;
    if IsDefined(settingsUserData) {
      this.m_isDlcSettings = settingsUserData.m_isDlcSettings;
    };
  }


  protected cb func OnUninitialize() -> Bool {
    ModSettings.GetInstance().isActive = false;
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnButtonRelease");
    this.m_menuEventDispatcher.UnregisterFromEvent(n"OnBack", this, n"OnBack");
    this.m_selectorCtrl.UnregisterFromCallback(n"OnItemActivated", this, n"OnMenuChanged");
    inkWidgetRef.GetControllerByType(this.m_applyButton, n"inkButtonController").UnregisterFromCallback(n"OnButtonClick", this, n"OnApplyButtonReleased");
    inkWidgetRef.GetControllerByType(this.m_resetButton, n"inkButtonController").UnregisterFromCallback(n"OnButtonClick", this, n"OnResetButtonReleased");
    inkWidgetRef.GetControllerByType(this.m_controllerButton, n"inkButtonController").UnregisterFromCallback(n"OnButtonClick", this, n"OnControllerButtonReleased");
    inkWidgetRef.GetControllerByType(this.m_defaultButton, n"inkButtonController").UnregisterFromCallback(n"OnButtonClick", this, n"OnDefaultButtonReleased");

    ModSettings.UnregisterListenerToModifications(this);
  }


  public final func EnableApplyButton() -> Void {
    inkWidgetRef.SetVisible(this.m_applyButton, true);
    this.m_applyButtonEnabled = true;
  }


  public final func DisableApplyButton() -> Void {
    this.m_applyButtonEnabled = false;
    inkWidgetRef.SetVisible(this.m_applyButton, false);
  }


  public final func IsApplyButtonEnabled() -> Bool {
    return this.m_applyButtonEnabled;
  }


  public final func EnableResetButton() -> Void {
    this.m_resetButtonEnabled = true;
    inkWidgetRef.SetVisible(this.m_resetButton, true);
  }


  public final func DisableResetButton() -> Void {
    this.m_resetButtonEnabled = false;
    inkWidgetRef.SetVisible(this.m_resetButton, false);
  }


  public final func IsResetButtonEnabled() -> Bool {
    return this.m_resetButtonEnabled;
  }


  public final func CheckButtons() -> Void {
    if ModSettings.GetInstance().changeMade {
      this.EnableApplyButton();
      this.EnableResetButton();
    } else {
      this.DisableApplyButton();
      this.DisableResetButton();
    };
  }


  public final func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    Log("[VAR] modified groupPath: " + NameToString(groupPath) + " varName: " + NameToString(varName));
    this.CheckButtons();
    for item in this.m_settingsElements {
      if Equals(item.GetGroupPath(), groupPath) && Equals(item.GetVarName(), varName) {
        item.Refresh();
      };
    };
  }


  public final func OnSettingsNotify(status: ConfigNotificationType) -> Void {
    switch status {
      case ConfigNotificationType.RestartRequiredConfirmed:
      case ConfigNotificationType.ChangesApplied:
      case ConfigNotificationType.Saved:
        this.CheckSettings();
        this.PopulateSettingsData();
        this.PopulateCategorySettingsOptions(-1);
        this.RefreshInputIcons();
        break;
      case ConfigNotificationType.ChangesLoadLastCheckpointApplied:
        this.CheckSettings();
        this.PopulateSettingsData();
        this.PopulateCategorySettingsOptions(-1);
        GameInstance.GetTelemetrySystem(this.GetPlayerControlledObject().GetGame()).LogLastCheckpointLoaded();
        this.GetSystemRequestsHandler().LoadLastCheckpoint(true);
        this.RefreshInputIcons();
        break;
      case ConfigNotificationType.ChangesLoadLastCheckpointRejected:
      case ConfigNotificationType.RestartRequiredRejected:
      case ConfigNotificationType.ChangesRejected:
        this.m_closeSettingsRequest = false;
        this.CheckSettings();
        this.PopulateSettingsData();
        this.PopulateCategorySettingsOptions(-1);
        this.RefreshInputIcons();
        break;
      case ConfigNotificationType.ErrorSaving:
        this.RequestClose();
        break;
      case ConfigNotificationType.Refresh:
        this.PopulateSettingsData();
        this.PopulateCategorySettingsOptions(-1);
        this.RefreshInputIcons();
    };
  }


  protected func SetLanguagePackageInstallProgress(progress: Float) -> Void {
    this.m_languageInstallProgressBar.SetProgress(progress);
  }


  protected func SetLanguagePackageInstallProgressBar(progress: Float, completed: Bool, started: Bool) -> Void {
    this.m_languageInstallProgressBar.SetProgressBarVisiblity(!completed && started);
    this.m_languageInstallProgressBar.SetProgress(progress);
  }


  protected cb func OnSetMenuEventDispatcher(menuEventDispatcher: wref<inkMenuEventDispatcher>) -> Bool {
    this.m_menuEventDispatcher = menuEventDispatcher;
    this.m_menuEventDispatcher.RegisterToEvent(n"OnBack", this, n"OnBack");
  }


  protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
    this.m_closeSettingsRequest = true;
    this.CheckSettings();
    ModSettings.AcceptChanges();
  }


  private final func RequestClose() -> Void {
    this.m_menuEventDispatcher.SpawnEvent(n"OnCloseModSettingsScreen");
  }


  private final func RequestRestoreDefaults() -> Void {
    let index: Int32 = this.m_selectorCtrl.GetToggledIndex();
    let mod: CName = this.m_data[index].label;
    ModSettings.RestoreDefaults(mod);
  }


  private final func CheckSettings() -> Void {
    if this.m_resetSettingsRequest {
      this.CheckRejectSettings();
    } else {
      this.CheckAcceptSettings();
    };
  }


  private final func CheckRejectSettings() -> Void {
    ModSettings.RejectChanges();
    this.m_resetSettingsRequest = false;
    if this.m_closeSettingsRequest {
      this.m_closeSettingsRequest = false;
      this.RequestClose();
    };
  }


  private final func CheckAcceptSettings() -> Void {
    ModSettings.AcceptChanges();
    if this.m_closeSettingsRequest {
      this.m_closeSettingsRequest = false;
      this.RequestClose();
    };
  }


  protected cb func OnMenuChanged(index: Int32, target: ref<ListItemController>) -> Bool {
    this.PlaySound(n"Button", n"OnPress");
    this.PopulateCategorySettingsOptions(index);
    (inkWidgetRef.GetController(this.m_scrollPanel) as inkScrollController).SetScrollPosition(0.00);
  }


  protected cb func OnApplyButtonReleased(controller: wref<inkButtonController>) -> Bool {
    this.OnApplyButton();
  }


  protected cb func OnResetButtonReleased(controller: wref<inkButtonController>) -> Bool {
    this.OnResetButton();
  }


  protected cb func OnBenchmarkButtonReleased(controller: wref<inkButtonController>) -> Bool {
    if this.IsBenchmarkPossible() {
      this.RunGraphicsBenchmark();
    };
  }


  protected cb func OnDefaultButtonReleased(controller: wref<inkButtonController>) -> Bool {
    this.RequestRestoreDefaults();
  }


  protected cb func OnLocalizationChanged(evt: ref<inkLocalizationChangedEvent>) -> Bool {
    let idx: Int32 = this.m_selectorCtrl.GetToggledIndex();
    this.PopulateCategories(idx);
    this.PopulateCategorySettingsOptions(idx);
    this.PopulateHints();
  }


  private final func PopulateHints() -> Void {
    this.m_buttonHintsController.ClearButtonHints();
    this.m_buttonHintsController.AddButtonHint(n"select", "UI-UserActions-Select");
    this.m_buttonHintsController.AddButtonHint(n"back", "Common-Access-Close");
    if !this.m_isDlcSettings {
      this.m_buttonHintsController.AddButtonHint(n"restore_default_settings", "UI-UserActions-RestoreDefaults");
    };
  }


  private final func OnApplyButton() -> Void {
    this.m_isKeybindingAlertEnabled = this.m_settings.GetMenuIndex() == 8;
    if !this.IsApplyButtonEnabled() {
      return;
    };
    Log("OnApplyButton");
    if this.m_settings.NeedsConfirmation() {
      this.m_settings.ConfirmChanges();
    } else {
      this.CheckSettings();
    };
  }


  private final func OnResetButton() -> Void {
    if !this.IsResetButtonEnabled() {
      return;
    };
    Log("OnResetButton");
    this.m_resetSettingsRequest = true;
    this.CheckSettings();
  }


  protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
    let currentToggledIndex: Int32 = this.m_selectorCtrl.GetToggledIndex();
    if evt.IsAction(n"prior_menu") {
      if currentToggledIndex < 1 {
        let listSize: Int32 = this.m_selectorCtrl.Size();
        this.m_selectorCtrl.SetToggledIndex(listSize - 1);
      } else {
        this.m_selectorCtrl.SetToggledIndex(currentToggledIndex - 1);
      };
    } else {
      if evt.IsAction(n"next_menu") {
        currentToggledIndex = this.m_selectorCtrl.GetToggledIndex();
        if currentToggledIndex >= this.m_selectorCtrl.Size() - 1 {
          this.m_selectorCtrl.SetToggledIndex(0);
        } else {
          this.m_selectorCtrl.SetToggledIndex(currentToggledIndex + 1);
        };
      } else {
        if evt.IsAction(n"restore_default_settings") {
          this.RequestRestoreDefaults();
        } else {
          return false;
        };
      };
    };
  }


  protected cb func OnSettingHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let currentItem: wref<SettingsSelectorController> = evt.GetCurrentTarget().GetController() as SettingsSelectorController;
    if IsDefined(currentItem) {
      let descriptionName: CName = currentItem.GetDescription();
      let description: String = GetLocalizedTextByKey(descriptionName);
      if StrLen(description) == 0 {
        if !Equals(descriptionName, n"None") {
          description = ToString(descriptionName);
        } else {
          description = "";
        };
      };
      let params: ref<inkTextParams>;
      let updatePolicy: ConfigVarUpdatePolicy = currentItem.GetVarUpdatePolicy();
      if Equals(updatePolicy, ConfigVarUpdatePolicy.ConfirmationRequired) {
        params = new inkTextParams();
        params.AddString("description", description);
        params.AddLocalizedString("additional_text", "LocKey#76947");
        inkTextRef.SetLocalizedTextScript(this.m_descriptionText, "LocKey#76949", params);
      } else {
        if Equals(updatePolicy, ConfigVarUpdatePolicy.RestartRequired) {
          params = new inkTextParams();
          params.AddString("description", description);
          params.AddLocalizedString("additional_text", "LocKey#76948");
          inkTextRef.SetLocalizedTextScript(this.m_descriptionText, "LocKey#76949", params);
        } else {
          inkTextRef.SetText(this.m_descriptionText, description, params);
        };
      };
      inkWidgetRef.SetVisible(this.m_descriptionText, true);
    };
  }


  protected cb func OnSettingHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    inkWidgetRef.SetVisible(this.m_descriptionText, false);
  }

  // creates an array of all mod names, their uncategorized settings, and their categories' names.
  // each category creates an array of their own settings
  private final func PopulateSettingsData() -> Void {
    // clears the array of mod names with
    ArrayClear(this.m_data);
    for modName in ModSettings.GetMods() {
      let currentMod: SettingsCategory;
      // the name
      currentMod.label = modName;
      // the uncategorized settings and data
      currentMod.options = ModSettings.GetVars(modName, n"None");
      currentMod.isEmpty = false;
      // each category (called subcategory) creates an array of their own settings' names
      for categoryName in ModSettings.GetCategories(modName) {
        let currentCategory: SettingsCategory;
        currentCategory.label = categoryName;
        // the settings data within this category
        currentCategory.options = ModSettings.GetVars(modName, categoryName);
        currentCategory.isEmpty = false;
        ArrayPush(currentMod.subcategories, currentCategory);
      };
      ArrayPush(this.m_data, currentMod);
    };
  }

  // used to populate mod names, not categories.
  // this code is left over from the vanilla menu where each tab in the menu is a category instead of a mod
  // in the vanilla menu, what would be categories of mods are just considered subcategories
  private final func PopulateCategories(idx: Int32) -> Void {
    // m_selectorCtrl: ref<ListController> (ListController located in listController.script) determines which setting is highlighted in the menu for the user, determined by the user navigating up/down or hovering with cursor
    this.m_selectorCtrl.Clear();
    for mod in this.m_data {
      if !mod.isEmpty {
        // ListItemData only contains a single variable
        // class ListItemData extends IScriptable { (located in listItemController.script)
	      //   var label : String;
        // }
        let modName: ref<ListItemData> = new ListItemData();
        modName.label = GetLocalizedTextByKey(mod.label);
        if StrLen(modName.label) == 0 {
          modName.label = ToString(mod.label);
        };
        // a list of mod names to keep track of which mod is currently selected by the user
        this.m_selectorCtrl.PushData(modName);
      };
    };
    this.m_selectorCtrl.Refresh();
    if idx >= 0 && idx < ArraySize(this.m_data) {
      this.m_selectorCtrl.SetToggledIndex(idx);
    } else {
      this.m_selectorCtrl.SetToggledIndex(0);
    };
  }

  // populates the settings of one category or uncategorized settings, depending on how this function is called
  private final func PopulateOptions(categorySettings: array<ref<ConfigVar>>) -> Void {
    let currentItem: wref<SettingsSelectorController>;
    for currentSetting in categorySettings {
      if IsDefined(currentSetting) && currentSetting.IsVisible() {
        let currentSettingsItemType: ConfigVarType = currentSetting.GetType();
        switch currentSettingsItemType {
          case ConfigVarType.Bool:
            currentItem = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingsOptionsList), n"settingsSelectorBool").GetController() as SettingsSelectorController;
            break;
          case ConfigVarType.Int:
            currentItem = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingsOptionsList), n"settingsSelectorInt").GetController() as SettingsSelectorController;
            break;
          case ConfigVarType.Float:
            currentItem = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingsOptionsList), n"settingsSelectorFloat").GetController() as SettingsSelectorController;
            break;
          case ConfigVarType.Name:
            currentItem = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingsOptionsList), n"settingsSelectorKeyBinding").GetController() as SettingsSelectorController;
            break;
          case ConfigVarType.IntList:
            currentItem = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingsOptionsList), n"settingsSelectorIntList").GetController() as SettingsSelectorController;
            break;
          case ConfigVarType.FloatList:
            currentItem = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingsOptionsList), n"settingsSelectorFloatList").GetController() as SettingsSelectorController;
            break;
          case ConfigVarType.StringList:
            currentItem = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingsOptionsList), n"settingsSelectorStringList").GetController() as SettingsSelectorController;
            break;
          case ConfigVarType.NameList:
            currentItem = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingsOptionsList), n"settingsSelectorNameList").GetController() as SettingsSelectorController;
            break;
          default:
            LogUIWarning("Cannot create UI settings drawer for " + NameToString(currentSetting.GetDisplayName()));
        };
        if IsDefined(currentItem) {
          currentItem.Setup(currentSetting, this.m_isPreGame);
          currentItem.RegisterToCallback(n"OnHoverOver", this, n"OnSettingHoverOver");
          currentItem.RegisterToCallback(n"OnHoverOut", this, n"OnSettingHoverOut");
          currentItem.Refresh();
          ArrayPush(this.m_settingsElements, currentItem);
        };
      };
    };
  }

  // categories are modNames and subcategories are just categories
  // SettingsCategory is a struct in settingsMain.script
  // "struct SettingsCategory {
  //   var label: CName;
  //   var subcategories: array<SettingsCategory>;
  //   var options: array<ConfigVar>;
  //   var isEmpty: Bool;
  //   default isEmpty = true;
  //   var groupPath: CName;
  // }"
  // this function is probably called when a mod tab has been selected.
  // this function then populates the visuals of the (sub)categories and settings (for each of those categories) for the selected mod.
  private final func PopulateCategorySettingsOptions(idx: Int32) -> Void {
    // this must be the list used to determine which setting is currently selected by the user within the selected mod tab, which is determined by m_selectorCtrl
    ArrayClear(this.m_settingsElements);
    // this must basically be the same list but used to visually write the settings on the menu
    inkCompoundRef.RemoveAllChildren(this.m_settingsOptionsList);
    // makes the description of the mod invisible by default
    inkWidgetRef.SetVisible(this.m_descriptionText, false);
    if idx < 0 {
      idx = this.m_selectorCtrl.GetToggledIndex();
    };
    // retrieves the mod with all data already present
    let mod: SettingsCategory = this.m_data[idx];
    // populates the uncategorized settings' visuals (inkWidget)
    this.PopulateOptions(mod.options);

    for category in mod.subcategories {
      // retrieves the controller for categories
      let categoryController: ref<SettingsCategoryController>
        = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingsOptionsList), n"settingsCategory").GetController() as SettingsCategoryController;
      if IsDefined(categoryController) {
        // makes the category name visible
        categoryController.Setup(category.label);
      };

      let settings = new SettingsMainGameController();
      settings.modReference = mod;
      settings.categoryReference = category;
      settings.IsResetButtonEnabled();

      let i = 0;
      while i < ArraySize(category.options) {
        if IsDefined(category.options[i]) {
          if !Equals(category.options[i].GetName(), settings.categoryReference.options[i].GetName()) {
            ArrayErase(category.options, i);
          } else {
            i += 1;
          };
        } else {
          break;
        };
      };
      // removes unwanted settings before populating
      // this.HideCategorySettings(mod, category);

      // this.PopulateOptions(category.options);
      // moved to inside HideCategorySettings();

      // after removing the unwanted settings, draw/populate all the categories
      this.PopulateOptions(category.options);
    };
    // just makes sure that this mod tab is still selected
    this.m_selectorCtrl.SetSelectedIndex(idx);
  }


  // protected final func HideCategorySettings(mod:SettingsCategory, category:SettingsCategory) -> Void {
  //   // up to 10 items can be dispensed so we start at 10 at subtract from that.
  //   let i: Int32 = 10;
  //   let settings: ref<evmMenuSettings> = new evmMenuSettings();
  //   if Equals(mod.label, n"Enhanced VM$") {
  //     if Equals(category.label, n"Items Hack Settings") {
  //       while i > settings.evmDispenseMax {
  //         ArrayErase(category.options, i);
  //         // for reference, this.m_selectorCtrl: ref<ListController> is used to determine which mod settings tab is currently selected by the user.
  //         // Since we are already in the Enhanced VM$ mod tab while removing settings, we don't need to change this.
  //         i -= 1;
  //       };
  //     };

  //     if Equals(category.label, n"Eddies Hack Settings") {
  //       if settings.evmEddiesOdds == 0 {
  //         ArrayErase(category.options, 1); // hides 'Max Eddies' int32
  //         ArrayErase(category.options, 1); // hides 'Min Eddies' int32
  //         ArrayErase(category.options, 1); // hides 'Eddies always possible' bool
  //         ArrayErase(category.options, 1); // hides 'Direct deposit' bool
  //         ArrayErase(category.options, 1); // hides 'Consolidated eddie bundles' int32
  //       };
  //       if Equals(settings.evmEddiesDeposit, true)
  //       && IsDefined(category.options[5]) {
  //         ArrayErase(category.options, 5); // hides 'Consolidated eddie bundles' int32
  //       };
  //     };

  //     if Equals(category.label, n"On-Hit 'Hooligan' Settings - Inspired by yakuzadeso") {
  //       if settings.evmHooliganItemOdds == 0
  //       && settings.evmHooliganEddiesOdds == 0
  //       && settings.evmHooliganJunkOdds == 0 { // if all three sliders off
  //         ArrayErase(category.options, 0); // index position 0: hides 'Drop behavior if breaking' becuz no items are dropping anyways
  //         ArrayErase(category.options, 4); // index position 5: hides 'Min Eddies' int32
  //         ArrayErase(category.options, 4); // index position 6: hides 'Max Eddies' int32
  //         ArrayErase(category.options, 4); // index position 7: hides 'Multiple drops possible' bool
  //       };
  //     };
  //     if ((settings.evmHooliganItemOdds == 0 && settings.evmHooliganEddiesOdds == 0)
  //     || (settings.evmHooliganItemOdds == 0 && settings.evmHooliganJunkOdds == 0)
  //     || (settings.evmHooliganEddiesOdds == 0 && settings.evmHooliganJunkOdds == 0))
  //     && IsDefined(category.options[8]) { // if only two sliders off
  //       ArrayErase(category.options, 7); // index position 7: hides 'Multiple drops possible' bool
  //     };
  //     if settings.evmHooliganEddiesOdds == 0 {
  //       if IsDefined(category.options[7]) { // if only the eddies slider is off
  //       // OR if the eddies slider and one other slider is off
  //         ArrayErase(category.options, 5); // index position 5: hides 'Min Eddies' int32
  //         ArrayErase(category.options, 5); // index position 6: hides 'Max Eddies' int32
  //       };
  //     };
  //   };

  //   // after removing the unwanted settings, draw/populate all the categories
  //   this.PopulateOptions(category.options);
  // }

  // this.PopulateSettingsData();
  // creates an array of all mod names (top-level array) with their uncategorized settings in a second-level array, and their categories' names in a second-level array with ~their~ settings as children in a third-level array.

  // this.PopulateCategories(num);
  // used to populate mod names, not categories, and visually draws them in their respective tabs.
  // this code is left over from the vanilla menu where each tab in the menu is a category instead of a mod
  // in the vanilla menu, what would be categories of mods are just considered subcategories

  // this.PopulateCategorySettingsOptions(-1);
  // this function is probably called when a mod tab has been selected.
  // this function then populates the visuals of the (sub)categories and settings (for each of those categories) for the selected mod.
}