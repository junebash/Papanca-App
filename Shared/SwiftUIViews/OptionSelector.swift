import SwiftUI


struct OptionSelector<Option>: View where Option: Hashable {
  let title: String
  let options: [Option]
  @Binding var selected: Option
  let optionTitle: (Option) -> String

  init(
    title: String,
    options: [Option],
    selected: Binding<Option>,
    optionTitle: @escaping (Option) -> String
  ) {
    self.title = title
    self.options = options
    self._selected = selected
    self.optionTitle = optionTitle
  }

  init(
    title: String,
    selected: Binding<Option>,
    optionTitle: @escaping (Option) -> String
  ) where Option: CaseIterable, Option.AllCases == [Option] {
    self.title = title
    self.options = Option.allCases
    self._selected = selected
    self.optionTitle = optionTitle
  }

  var body: some View {
    Picker(title, selection: $selected) {
      ForEach(options, id: \.self) { option in
        Text(optionTitle(option))
          .tag(option)
      }
    }.pickerStyle(.segmented)
  }
}
