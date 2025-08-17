import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "usersAvailable", "productsAvailable", "assignForm", "unassignForm"
  ]

  static values = {
    assignMessage: { type: String, default: "Please select at least one user and one product to assign licenses." },
    unassignMessage: { type: String, default: "Please select at least one user and one product to remove licenses." }
  }

  submitAssign(event) {
    event.preventDefault()
    
    const { selectedUsers, selectedProducts } = this.getSelectedValues()
    
    if (!this.validateSelection(selectedUsers, selectedProducts, this.assignMessageValue)) {
      return
    }

    this.createAssignmentInputs(selectedUsers, selectedProducts)
    this.assignFormTarget.submit()
  }

  submitUnassign(event) {
    event.preventDefault()

    const { selectedUsers, selectedProducts } = this.getSelectedValues()

    if (!this.validateSelection(selectedUsers, selectedProducts, this.unassignMessageValue)) {
      return
    }

    this.addUnassignInputs(selectedUsers, selectedProducts)
    this.unassignFormTarget.submit()
  }

  getSelectedValues() {
    const selectedUsers = Array.from(this.usersAvailableTarget.selectedOptions)
      .map(option => option.value)
    const selectedProducts = Array.from(this.productsAvailableTarget.selectedOptions)
      .map(option => option.value)
    
    return { selectedUsers, selectedProducts }
  }

  validateSelection(users, products, message) {
    if (users.length === 0 || products.length === 0) {
      alert(message)
      return false
    }
    return true
  }

  createAssignmentInputs(userIds, productIds) {
    this.clearFormInputs(this.assignFormTarget, 'input[name*="assignments["]')

    let index = 0
    userIds.forEach(userId => {
      productIds.forEach(productId => {
        this.appendInputsToForm(this.assignFormTarget, [
          { name: `assignments[${index}][user_id]`, value: userId },
          { name: `assignments[${index}][product_id]`, value: productId }
        ])
        index++
      })
    })
  }

  addUnassignInputs(userIds, productIds) {
    this.clearFormInputs(this.unassignFormTarget, 'input[name*="_ids[]"]')

    const userInputs = userIds.map(id => ({ name: 'user_ids[]', value: id }))
    const productInputs = productIds.map(id => ({ name: 'product_ids[]', value: id }))
    
    this.appendInputsToForm(this.unassignFormTarget, [...userInputs, ...productInputs])
  }

  appendInputsToForm(form, inputsData) {
    inputsData.forEach(({ name, value }) => {
      const input = this.createHiddenInput(name, value)
      form.appendChild(input)
    })
  }

  createHiddenInput(name, value) {
    const input = document.createElement('input')
    input.type = 'hidden'
    input.name = name
    input.value = value
    return input
  }

  clearFormInputs(form, selector) {
    const existingInputs = form.querySelectorAll(selector)
    existingInputs.forEach(input => input.remove())
  }

  clearAssignInputs() {
    this.clearFormInputs(this.assignFormTarget, 'input[name*="assignments["]')
  }

  clearUnassignInputs() {
    this.clearFormInputs(this.unassignFormTarget, 'input[name*="_ids[]"]')
  }
}
