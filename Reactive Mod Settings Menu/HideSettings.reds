@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if Equals(this.modReference.isEmpty, false) {
    let mod = this.modReference;
    let settings: ref<evmMenuSettings> = new evmMenuSettings();
    if Equals (this.categoryReference.isEmpty, false) {
      let category = this.categoryReference;
      if Equals(mod.label, n"Enhanced VM$") {
        if Equals(category.label, n"Items Hack Settings") {
          let i: Int32 = 10;
          // up to 10 items can be dispensed so we start at 10 at subtract from that.
          while i > settings.evmDispenseMax {
            ArrayErase(category.options, i);
            // for reference, this.m_selectorCtrl: ref<ListController> is used to determine which mod settings tab is currently selected by the user.
            // Since we are already in the Enhanced VM$ mod tab while removing settings, we don't need to change this.
            i -= 1;
          };
        };

        // if Equals(category.label, n"Eddies Hack Settings") {
        //   if settings.evmEddiesOdds == 0 {
        //     ArrayErase(category.options, 1); // hides 'Max Eddies' int32
        //     ArrayErase(category.options, 1); // hides 'Min Eddies' int32
        //     ArrayErase(category.options, 1); // hides 'Eddies always possible' bool
        //     ArrayErase(category.options, 1); // hides 'Direct deposit' bool
        //     ArrayErase(category.options, 1); // hides 'Consolidated eddie bundles' int32
        //   };
        //   if Equals(settings.evmEddiesDeposit, true)
        //   && IsDefined(category.options[5]) {
        //     ArrayErase(category.options, 5); // hides 'Consolidated eddie bundles' int32
        //   };
        // };

        // if Equals(category.label, n"On-Hit 'Hooligan' Settings - Inspired by yakuzadeso") {
        //   if settings.evmHooliganItemOdds == 0
        //   && settings.evmHooliganEddiesOdds == 0
        //   && settings.evmHooliganJunkOdds == 0 { // if all three sliders off
        //     ArrayErase(category.options, 0); // index position 0: hides 'Drop behavior if breaking' becuz no items are dropping anyways
        //     ArrayErase(category.options, 4); // index position 5: hides 'Min Eddies' int32
        //     ArrayErase(category.options, 4); // index position 6: hides 'Max Eddies' int32
        //     ArrayErase(category.options, 4); // index position 7: hides 'Multiple drops possible' bool
        //   };
        // };
        // if ((settings.evmHooliganItemOdds == 0 && settings.evmHooliganEddiesOdds == 0)
        // || (settings.evmHooliganItemOdds == 0 && settings.evmHooliganJunkOdds == 0)
        // || (settings.evmHooliganEddiesOdds == 0 && settings.evmHooliganJunkOdds == 0))
        // && IsDefined(category.options[8]) { // if only two sliders off
        //   ArrayErase(category.options, 7); // index position 7: hides 'Multiple drops possible' bool
        // };
        // if settings.evmHooliganEddiesOdds == 0 {
        //   if IsDefined(category.options[7]) { // if only the eddies slider is off
        //   // OR if the eddies slider and one other slider is off
        //     ArrayErase(category.options, 5); // index position 5: hides 'Min Eddies' int32
        //     ArrayErase(category.options, 5); // index position 6: hides 'Max Eddies' int32
        //   };
        // };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    } else {
      if Equals(mod.label, n"Enhanced VM$") {
        // remove uncategorized settings here
      };

      ArrayClear(this.modReference.options);
      for option in mod.options {
        ArrayPush(this.modReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if Equals(this.modReference.isEmpty, false) {
    let mod = this.modReference;
    let settings: ref<evmMenuSettings> = new evmMenuSettings();
    if Equals (this.categoryReference.isEmpty, false) {
      let category = this.categoryReference;
      if Equals(mod.label, n"Enhanced VM$") {
        // if Equals(category.label, n"Items Hack Settings") {
        //   let i: Int32 = 10;
        //   // up to 10 items can be dispensed so we start at 10 at subtract from that.
        //   while i > settings.evmDispenseMax {
        //     ArrayErase(category.options, i);
        //     // for reference, this.m_selectorCtrl: ref<ListController> is used to determine which mod settings tab is currently selected by the user.
        //     // Since we are already in the Enhanced VM$ mod tab while removing settings, we don't need to change this.
        //     i -= 1;
        //   };
        // };

        if Equals(category.label, n"Eddies Hack Settings") {
          if settings.evmEddiesOdds == 0 {
            ArrayErase(category.options, 1); // hides 'Max Eddies' int32
            ArrayErase(category.options, 1); // hides 'Min Eddies' int32
            ArrayErase(category.options, 1); // hides 'Eddies always possible' bool
            ArrayErase(category.options, 1); // hides 'Direct deposit' bool
            ArrayErase(category.options, 1); // hides 'Consolidated eddie bundles' int32
          };
          if Equals(settings.evmEddiesDeposit, true)
          && IsDefined(category.options[5]) {
            ArrayErase(category.options, 5); // hides 'Consolidated eddie bundles' int32
          };
        };

        if Equals(category.label, n"On-Hit 'Hooligan' Settings - Inspired by yakuzadeso") {
          if settings.evmHooliganItemOdds == 0
          && settings.evmHooliganEddiesOdds == 0
          && settings.evmHooliganJunkOdds == 0 { // if all three sliders off
            ArrayErase(category.options, 0); // index position 0: hides 'Drop behavior if breaking' becuz no items are dropping anyways
            ArrayErase(category.options, 4); // index position 5: hides 'Min Eddies' int32
            ArrayErase(category.options, 4); // index position 6: hides 'Max Eddies' int32
            ArrayErase(category.options, 4); // index position 7: hides 'Multiple drops possible' bool
          };
        };
        if ((settings.evmHooliganItemOdds == 0 && settings.evmHooliganEddiesOdds == 0)
        || (settings.evmHooliganItemOdds == 0 && settings.evmHooliganJunkOdds == 0)
        || (settings.evmHooliganEddiesOdds == 0 && settings.evmHooliganJunkOdds == 0))
        && IsDefined(category.options[8]) { // if only two sliders off
          ArrayErase(category.options, 7); // index position 7: hides 'Multiple drops possible' bool
        };
        if settings.evmHooliganEddiesOdds == 0 {
          if IsDefined(category.options[7]) { // if only the eddies slider is off
          // OR if the eddies slider and one other slider is off
            ArrayErase(category.options, 5); // index position 5: hides 'Min Eddies' int32
            ArrayErase(category.options, 5); // index position 6: hides 'Max Eddies' int32
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    } else {
      if Equals(mod.label, n"Enhanced VM$") {
        // remove uncategorized settings here
      };

      ArrayClear(this.modReference.options);
      for option in mod.options {
        ArrayPush(this.modReference.options, option);
      };
    };
  };
  return wrappedMethod();
}
