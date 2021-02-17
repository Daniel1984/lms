import axios from 'axios'

const API_ENDPOINT = 'https://ifuo4f9yhd.execute-api.eu-central-1.amazonaws.com/prod/books'

export function createBook(payload) {
  return axios.post(API_ENDPOINT, payload)
}

export function updateBook(payload) {
  return axios.put(API_ENDPOINT, payload)
}

export function getBook(id, author) {
  return axios.get(`${API_ENDPOINT}?bookID=${id}&author=${author}`)
}

export function getBooks() {
  return axios.get(API_ENDPOINT)
}

export function getBookReports(id) {
  return axios.get(`${process.env.BOOKS_URL}/books/report`)
}
