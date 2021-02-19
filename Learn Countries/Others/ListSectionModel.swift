//
//  ListSectionModel.swift
//  Learn Countries
//
//  Created by Kaushal on 18/02/21.
//

import Foundation

protocol SectionModelType {
    associatedtype HeaderModelType
    associatedtype RowModelType
    associatedtype FooterModelType

    var header: HeaderModelType? { get }
    var footer: FooterModelType? { get }
    var rows: [RowModelType] { get }
    var totalRows: Int { get }
}

public struct SectionModel<HeaderModelType, RowModelType, FooterModelType>: SectionModelType {
    /// The section header model
    public var header: HeaderModelType?

    /// The section footer model
    public var footer: FooterModelType?

    /// The section's rows model
    public var rows: [RowModelType]

    var totalRows: Int {
            return rows.count
    }

    public var currentCount: Int {
        return rows.count
    }

    public init(header: HeaderModelType? = nil,
                footer: FooterModelType? = nil,
                rows: [RowModelType]
                )
    {
        self.header = header
        self.footer = footer
        self.rows = rows
    }

}

extension Array where Element: SectionModelType {
    func contains(indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return indices.contains(section) && self[section].rows.indices.contains(row)
    }

    func row(at indexPath: IndexPath) -> Element.RowModelType? {
        guard contains(indexPath: indexPath) else {
            print("(\(indexPath)) out of range")
            return nil
        }
        return self[indexPath.section]
            .rows[indexPath.row]
    }

    
}

protocol ViewModelSectionType {
    associatedtype Header: Equatable
    associatedtype Row
    associatedtype Footer
    typealias Section = SectionModel<Header, Row, Footer>
    var sections: [Section] { get set }
}

