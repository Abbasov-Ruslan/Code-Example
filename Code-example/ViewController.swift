//
//  ViewController.swift
//  Code-example
//
//  Created by Ruslan Abbasov on 11.10.2022.
//

import Combine
import Foundation

protocol SetupPayModelProtocol {
    var error: AnyPublisher<APIError, Never> { get }
    var invalidField: AnyPublisher<InputViewModel, Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
    var resumeFlow: AnyPublisher<Void, Never> { get }
    var flowModel: SetupPayFlowModel { get set }
    func fillProperties()
}

final class SetupPayFlowModel {

    private var cancellables = Set<AnyCancellable>()

    private(set) var registrationType: RegistrationType = .notRegistered

    func setRegistrationType(_ type: RegistrationType) {
        registrationType = type
    }

    var onboardingProgressModel: OnboardingProgressModel {
        onboardingProgressModelSubject.value
    }
    private let onboardingProgressModelSubject: CurrentValueSubject<OnboardingProgressModel, Never>

    init(_ onboardingProgressModel: OnboardingProgressModel) {
        registrationType = onboardingProgressModel.registrationType
        self.onboardingProgressModelSubject = CurrentValueSubject(onboardingProgressModel)

        let user = DataPersistenceManager.shared.currentUser.value

        self.lastName = user?.lastName ?? ""
        self.firstName = user?.firstName ?? ""
        self.email = user?.email ?? ""
        self.country = "US"
        self.companyCountry = "US"
    }

    // MARK: - Personal Info

    private(set) var firstName: String = ""
    private(set) var lastName: String = ""
    private(set) var email: String = ""
    private(set) var dateOfBirth: Date = Date()
    private(set) var streetName: String = ""
    private(set) var apartment: String = ""
    private(set) var zipCode: String = ""
    private(set) var socialSecurityNumber: String = ""
    private(set) var phoneNumber: String = ""
    private(set) var city: String = ""
    private(set) var state: String = ""
    private(set) var country: String = ""

    // swiftlint:disable:next function_parameter_count
    func fillPersonalInfoFields(_ firstName: String, _ lastName: String, _ email: String,
                                _ dateOfBirth: Date, _ streetName: String, _ apartment: String,
                                _ zipCode: String, _ socialSecurityNumber: String, _ phoneNumber: String,
                                _ city: String, _ state: String, _ country: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.streetName = streetName
        self.apartment = apartment
        self.zipCode = zipCode
        self.socialSecurityNumber = socialSecurityNumber
        self.phoneNumber = phoneNumber
        self.city = city
        self.state = state
        self.country = country
    }

    // MARK: - Company Info

    private(set) var companyName: String = ""
    private(set) var companyStreetName: String = ""
    private(set) var companyApartment: String = ""
    private(set) var companyZip: String = ""
    private(set) var companyCity: String = ""
    private(set) var companyState: String = ""
    private(set) var companyCountry: String = ""
    private(set) var addressSameAsPersonal: Bool = true

    private var companyId: String = ""

    // swiftlint:disable:next function_parameter_count
    func fillCompanyFields(_ companyName: String, _ addressSameAsPersonal: Bool, _ companyStreetName: String,
                           _ companyApartment: String, _ companyZip: String, _ companyCity: String,
                           _ companyState: String, _ companyCountry: String) {
        self.companyName = companyName
        self.companyStreetName = addressSameAsPersonal ? streetName : companyStreetName
        self.companyApartment = addressSameAsPersonal ? apartment : companyApartment
        self.companyZip = addressSameAsPersonal ? zipCode : companyZip
        self.companyCity = addressSameAsPersonal ? city : companyCity
        self.companyState = addressSameAsPersonal ? state : companyState
        self.companyCountry = addressSameAsPersonal ? country : companyCountry
        self.addressSameAsPersonal = addressSameAsPersonal
    }

    // MARK: - Delegate Info

    private(set) var delegateType: DelegateType = .me

    private var delegateFirstName: String = ""
    private var delegateLastName: String = ""
    private var delegateEmail: String = ""
    private var delegateDateOfBirth: Date = Date()
    private var delegateStreetName: String = ""
    private var delegateApartment: String = ""
    private var delegateZipCode: String = ""
    pri

    > Никита Афонасов:
    vate var delegateSocialSecurityNumber: String = ""
    private var delegatePhoneNumber: String = ""
    private var delegateCity: String = ""
    private var delegateState: String = ""
    private var delegateCountry: String = ""

    func setDelegateType(_ type: DelegateType) {
        delegateType = type
        if delegateType == .me { setCurrentUserAsDelegate() }
    }

    private func setCurrentUserAsDelegate() {
        delegateFirstName = firstName
        delegateLastName = lastName
        delegateEmail = email
        delegateDateOfBirth = dateOfBirth
        delegateStreetName = streetName
        delegateApartment = apartment
        delegateZipCode = zipCode
        delegateSocialSecurityNumber = socialSecurityNumber
        delegatePhoneNumber = phoneNumber
        delegateCity = city
        delegateState = state
        delegateCountry = country
    }

    // swiftlint:disable:next function_parameter_count
    func fillDelegateFields(_ firstName: String, _ lastName: String, _ email: String,
                            _ dateOfBirth: Date, _ streetName: String, _ apartment: String,
                            _ zipCode: String, _ socialSecurityNumber: String, _ phoneNumber: String,
                            _ city: String, _ state: String, _ country: String) {
        self.delegateFirstName = firstName
        self.delegateLastName = lastName
        self.delegateEmail = email
        self.delegateDateOfBirth = dateOfBirth
        self.delegateStreetName = streetName
        self.delegateApartment = apartment
        self.delegateZipCode = zipCode
        self.delegateSocialSecurityNumber = socialSecurityNumber
        self.delegatePhoneNumber = phoneNumber
        self.delegateCity = city
        self.delegateState = state
        self.delegateCountry = country
    }

    // MARK: - Account Info

    private(set) var url: String = ""
    private(set) var companyPhone: String = ""
    private(set) var companyEmail: String = ""
    private(set) var taxId: String = ""
    private(set) var taxType: String = ""

    func fillAccountFields(_ url: String, _ companyPhone: String, _ companyEmail: String,
                           _ taxId: String, _ taxType: String) {
        self.url = url
        self.companyPhone = companyPhone
        self.companyEmail = companyEmail
        self.taxId = taxId
        self.taxType = taxType
    }

    // MARK: - Billing Info

    private(set) var accountType: String = ""
    private(set) var accountHolderName: String = ""
    private(set) var accountNumber: String = ""
    private(set) var routingNumber: String = ""

    func fillBillingInfoFields(_ accountType: String, accountHolderName: String, _ accountNumber: String, _ routingNumber: String) {
        self.accountType = accountType
        self.accountHolderName = accountHolderName
        self.accountNumber = accountNumber
        self.routingNumber = routingNumber
    }

    // MARK: - Alternate payment

    private(set) var paypalEmail: String?
    private(set) var venmoUsername: String?

    func isPaypalSet() -> Bool {
        return paypalEmail != nil
    }

    func isVenmoSet() -> Bool {
        return venmoUsername != nil
    }

    func fillAlternatePaymentsVenmo(venmoUsername: String?) {
        self.venmoUsername = venmoUsername
    }

    func fillAlternatePaymentsPaypal(paypalEmail: String?) {
        self.paypalEmail = paypalEmail
    }

    // MARK: -

    func fillBusinessAddressSameAsPersonalIfNeeded() {
        guard registrationType == .business else {
            return
        }

        companyStreetName = streetName
        companyApartment = apartment
        companyCity = city
        companyState = state
        companyCountry = country
        companyZip = zipCode
    }

    func retrivePersonalDataForBusinessIfNeeded() {
        guard registrationType == .business, let storedData = DataPersistenceManager.shared.getBusinessRegistrationModel() else {
            return
        }

        streetName = storedData.address.address1
        apartment = storedData.address.address2
        city = storedData.address.city
        state = storedData.address.state
        country = storedData.address.country
        zipCode = storedData.address.zip5
    }

    func saveDataForBusinessIfNeeded() {
        guard registrationType == .business else {
            return
        }

        DataPersistenceManager.shared.updateBusinessRegistrationModel(businessRegistrationModel)
    }

    func dropDataForBusinessIfNeeded() {
        guard registrationType == .business else {
            return
        }

        DataPersistenceManager.shared.resetBusinessRegistrationModel()
    }

    func addAlternatePayments() -> AnyPubl

    > Никита Афонасов:
    isher<Void, APIError> {
    alternatePaymentsModel.addAlternatePayments().share().eraseToAnyPublisher()
    }


    // MARK: -

    func setRegistrationType() -> AnyPublisher<Void, APIError> {
        OnboardingProgressModel(registrationType: self.registrationType, onboardingStep: .notStarted)
            .update()
            .map { [weak self] onboardingProgressModel in
                self?.onboardingProgressModelSubject.value = onboardingProgressModel
                return
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Upload

    func uploadPersonalInfo() -> AnyPublisher<Void, APIError> {
        personalRegistrationModel.register()
            .flatMap { [weak self] () -> AnyPublisher<OnboardingProgressModel, APIError> in
                guard let type = self?.registrationType else {
                    return Fail(error: APIError.genericError(description: "Not really an API error")).eraseToAnyPublisher()
                }
                return OnboardingProgressModel(registrationType: type, onboardingStep: .personRegistered).update()
            }
            .map { [weak self] onboardingProgressModel in
                self?.onboardingProgressModelSubject.value = onboardingProgressModel
                return
            }
            .eraseToAnyPublisher()
    }

    func uploadAccountInfo() -> AnyPublisher<Void, APIError> {
        accountRegistrationModel.register()
            .flatMap { [weak self] () -> AnyPublisher<OnboardingProgressModel, APIError> in
                guard let type = self?.registrationType else {
                    return Fail(error: APIError.genericError(description: "Not really an API error")).eraseToAnyPublisher()
                }
                return OnboardingProgressModel(registrationType: type, onboardingStep: .accountRegistered).update()
            }
            .map { [weak self] onboardingProgressModel in
                self?.onboardingProgressModelSubject.value = onboardingProgressModel
                return
            }
            .eraseToAnyPublisher()
    }

    func uploadBusinessInfo() -> AnyPublisher<Void, APIError> {
        businessRegistrationModel.register().flatMap { [weak self] businessResponseModel -> AnyPublisher<OnboardingProgressModel, APIError> in
            guard let type = self?.registrationType else {
                return Fail(error: APIError.genericError(description: "Not really an API error")).eraseToAnyPublisher()
            }
            self?.companyId = businessResponseModel.id
            return OnboardingProgressModel(registrationType: type, onboardingStep: .businessRegistered).update()
        }
        .map { [weak self] onboardingProgressModel in
            self?.onboardingProgressModelSubject.value = onboardingProgressModel
            return
        }
        .eraseToAnyPublisher()
    }

    func uploadDelegateInfo() -> AnyPublisher<Void, APIError> {
        delegateRegistrationModel.register()
            .flatMap { [weak self] () -> AnyPublisher<OnboardingProgressModel, APIError> in
                guard let type = self?.registrationType else {
                    return Fail(error: APIError.genericError(description: "Not really an API error")).eraseToAnyPublisher()
                }
                return OnboardingProgressModel(registrationType: type, onboardingStep: .businessDelegateRegistered).update()
            }
            .map { [weak self] onboardingProgressModel in
                self?.onboardingProgressModelSubject.value = onboardingProgressModel
                return
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Private

    private var personalRegistrationModel: PersonalRegistrationModel {
        PersonalRegistrationModel(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber,
                                  address: Address(type: .home, address1: streetName, address2: apartment,
                                                   city: city, state: state, country: country, zip5: zipCode),
                                  dateOfBirth: dateOfBirth.requestStringFromDate(), socialSecurityNumber: socialSecurityNumber,
                                  delegateForBusiness: nil)
    }

    private var businessRegistrationModel: BusinessRegistrationModel {
        BusinessRegistrationModel(legalName: companyName, brand: "", email: companyEmail, phoneNumber: companyPhone, websiteUrl: url,
                                  address: Address(type: addressSameAsPersonal ? .home : .legal, address1: companyStreetName,
                                                   address2: companyApartment, city: companyCity, state: companyState,
                                                   country: companyCountry, zip5: companyZip),
                                  taxId: taxId, taxType: taxType.lowercased())
    }

    private var delegateRegistrationModel: PersonalRegistrationModel {
        PersonalRegistrationModel(firstName: delegateFirstName, lastName: delegateLastName, email: delegateEmail,
                                  phoneNumber: delegatePhoneNumber,
                                  address: Address(type: .home, address1: delegateStreetName, address2: delegateApartment,
                                                   city: delegateCity, state: delegateState, country: delegateCountry, zip5: delegateZipCode),
                                  dateOfBirth: delegateDateOfBirth.requestStringFromDate(), socialSecurityNumber: delegateSocialSecurityNumber,
                                  delegateForBusiness: companyId)
    }

    private var accountRegistrationModel: AccountRegistrationModel {
        AccountRegistrationModel(accountType: accountType, holderName: accountHolderName, accountNumber: accountNumber,
                                 routingNumber: routingNumber, isBusinessAccount: registrationType == .business, brand: companyId)
    }

    private var alternatePaymentsModel: AlternatePaymentsModel {
        AlternatePaymentsModel(paypalEmail: paypalEmail, venmoUsername: venmoUsername)
    }
}

extension SetupPayFlowModel {

    enum DelegateType {
        case me
        case another
    }

}

