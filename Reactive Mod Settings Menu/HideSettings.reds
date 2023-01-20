// shared dependencies absolutely required
// VendingMachineHackedEffect doesn't require anything else
// // // VendingMachineHacking requires VendingMachineHackedEffect
// // // DropPointHacking requires VendingMachineHackedEffect
// AllMachinesOnHitEvent doesn't require anything else
// VendingMachineMalfunctions doesn't require anything else
// DropPointMalfunctions doesn't require anything else

// This is for uncategorized settings, but I don't have any
// @wrapMethod(SettingsMainGameController)
// protected func IsResetButtonEnabled() -> Bool {
//   if !this.modReference.isEmpty {
//     let mod = this.modReference;
//     let settings = new EVMMenuSettings();
//     if Equals (this.categoryReference.isEmpty, true) {
//       if Equals(mod.label, n"Enhanced VM$") {
//         // settings to be removed
//       };

//       ArrayClear(this.modReference.options);
//       for option in mod.options {
//         ArrayPush(this.modReference.options, option);
//       };
//     };
//   };
//   return wrappedMethod();
// }

// VendingMachineHackedEffect doesn't require anything else
@if(ModuleExists("VendingMachineHackedEffect"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;
      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Items Hack Settings") {
          let i: Int32 = 5;
          // up to 5 items can be dispensed so we start at 5 at subtract from that.
          while i > settings.dispenseMax {
            ArrayErase(category.options, i);
            i -= 1;
          };
        };

        if Equals(category.label, n"Eddies Hack Settings") {
          if settings.eddiesDropOdds == 0 {
            let i = 0;
            while i <= settings.EddiesHackSettingsCount() {
              if IsDefined(category.options[i]) {
                if Equals(category.options[i].GetDisplayName(), n"Max Eddies")
                || Equals(category.options[i].GetDisplayName(), n"Min Eddies")
                || Equals(category.options[i].GetDisplayName(), n"Eddies always possible")
                || Equals(category.options[i].GetDisplayName(), n"Direct deposit")
                || Equals(category.options[i].GetDisplayName(), n"Consolidate eddie bundles") {
                  ArrayErase(category.options, i);
                } else {
                  i += 1;
                };
              } else {
                break;
              };
            };
          };
          if Equals(settings.eddiesDeposit, true) {
            let i = 0;
            while i <= settings.EddiesHackSettingsCount() {
              if IsDefined(category.options[i]) {
                if Equals(category.options[i].GetDisplayName(), n"Consolidate eddie bundles") {
                  ArrayErase(category.options, i);
                } else {
                  i += 1;
                };
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// VendingMachineHackedEffect doesn't require anything else
@if(!ModuleExists("VendingMachineHackedEffect"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Items Hack Settings") {
          let i = 0;
          while i < ArraySize(settings.ItemHackSettingsToArray()) {
            ArrayErase(category.options, 0);
            i += 1;
          };
        };

        if Equals(category.label, n"Eddies Hack Settings") {
          let i = 0;
          while i <= settings.EddiesHackSettingsCount() {
            ArrayErase(category.options, 0);
            i += 1;
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// // // VendingMachineHacking requires VendingMachineHackedEffect
// // // includes Rob ice machines and Rob arcade machines
@if(!ModuleExists("VendingMachineHacking"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  // this is for arcade hacking.
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Eddies Hack Settings") {
          let i = 0;
          while i <= settings.EddiesHackSettingsCount() {
            if IsDefined(category.options[i]) {
              if Equals(category.options[i].GetDisplayName(), n"Rob ice machines")
              || Equals(category.options[i].GetDisplayName(), n"Rob arcade machines") {
                ArrayErase(category.options, i);
              } else {
                i += 1;
              };
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// // // DropPointHacking requires VendingMachineHackedEffect
// // // Includes Rob drop points
@if(!ModuleExists("DropPointHacking"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Eddies Hack Settings") {
          let i = 0;
          while i <= settings.EddiesHackSettingsCount() {
            if IsDefined(category.options[i]) {
              if Equals(category.options[i].GetDisplayName(), n"Rob drop points") {
                ArrayErase(category.options, i);
              } else {
                i += 1;
              };
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// AllMachinesOnHitEvent doesn't require anything else
@if(ModuleExists("AllMachinesOnHitEvent"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"On-Hit Vandal Settings") {
          let i = 0;
          while i < settings.OnHitSettingsCount() {
            if IsDefined(category.options[i]) {
              let didDelete = false;
              if settings.onHitItemOdds == 0
              && settings.onHitEddiesOdds == 0
              && settings.onHitJunkOdds == 0 { // if all three sliders off
                if Equals(category.options[i].GetDisplayName(), n"Drop behavior when breaking")
                || Equals(category.options[i].GetDisplayName(), n"Min eddies")
                || Equals(category.options[i].GetDisplayName(), n"Max eddies")
                || Equals(category.options[i].GetDisplayName(), n"Simultaneous drops") {
                  ArrayErase(category.options, i);
                  didDelete = true;
                };
              };

              if ((settings.onHitItemOdds == 0 && settings.onHitEddiesOdds == 0)
              || (settings.onHitItemOdds == 0 && settings.onHitJunkOdds == 0)
              || (settings.onHitEddiesOdds == 0 && settings.onHitJunkOdds == 0)) { // if only two sliders off
                if Equals(category.options[i].GetDisplayName(), n"Simultaneous drops") {
                  ArrayErase(category.options, i);
                  didDelete = true;
                };
              };

              if settings.onHitEddiesOdds == 0 { // if only the eddies slider is off
                if Equals(category.options[i].GetDisplayName(), n"Max eddies")
                || Equals(category.options[i].GetDisplayName(), n"Min eddies") {
                // OR if the eddies slider and one other slider is off
                ArrayErase(category.options, i);
                didDelete = true;
                };
              };

              if !didDelete { i += 1; };
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// AllMachinesOnHitEvent doesn't require anything else
@if(!ModuleExists("AllMachinesOnHitEvent"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"On-Hit Vandal Settings") {
          let i = 0;
          while i < settings.OnHitSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// VendingMachineMalfunctions doesn't require anything else
@if(ModuleExists("VendingMachineMalfunctions"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Malfunctions: Vending Machines") {
          if settings.vendingMachineMalfunctionRate == 0 {
            let i = settings.VendingMachineMalfunctionsSettingsCount()-1; // returns 4-1 -> returns 3
            while i > 0 {
              if IsDefined(category.options[i]) {
                ArrayErase(category.options, i);
                i -= 1;
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// VendingMachineMalfunctions doesn't require anything else
@if(!ModuleExists("VendingMachineMalfunctions"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Malfunctions: Vending Machines") {
          let i = 0;
          while i < settings.VendingMachineMalfunctionsSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// DropPointMalfunctions doesn't require anything else
@if(ModuleExists("DropPointMalfunctions"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Malfunctions: Drop Points") {
          if settings.dropPointMalfunctionRate == 0 {
            let i = settings.DropPointMalfunctionsSettingsCount()-1; // returns 4-1 -> returns 3
            while i > 0 {
              if IsDefined(category.options[i]) {
                ArrayErase(category.options, i);
                i -= 1;
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// DropPointMalfunctions doesn't require anything else
@if(!ModuleExists("DropPointMalfunctions"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Malfunctions: Drop Points") {
          let i = 0;
          while i < settings.DropPointMalfunctionsSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// shared dependencies absolutely required
// VendingMachineHackedEffect doesn't require anything else
// // // VendingMachineHacking requires VendingMachineHackedEffect
// // // DropPointHacking requires VendingMachineHackedEffect
// AllMachinesOnHitEvent doesn't require anything else
// VendingMachineMalfunctions doesn't require anything else
// DropPointMalfunctions doesn't require anything else