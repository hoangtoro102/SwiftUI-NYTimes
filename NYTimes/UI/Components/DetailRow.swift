//
//  DetailRow.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI

struct DetailRow: View {
    let titleLabel: Text
    let dateLabel: Text
    
    init(titleLabel: Text, dateLabel: Text) {
        self.titleLabel = titleLabel
        self.dateLabel = dateLabel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleLabel
                .font(.headline)
                .truncationMode(.tail)
            dateLabel
                .font(.callout)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
    }
}

#if DEBUG
struct DetailRow_Previews: PreviewProvider {
    static var previews: some View {
        DetailRow(titleLabel: Text("4,000 Beagles Are Being Rescued From a Virginia Facility. Now They Need New Homes."), dateLabel: Text("12/12/2022"))
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
#endif
