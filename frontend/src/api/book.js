import axios from 'axios'

export function createBook(payload) {
  return Promise.resolve({})
  // return axios.post(`${process.env.BOOK_URL}/books`, payload)
}

export function updateBook(payload) {
  return Promise.resolve({})
  // return axios.put(`${process.env.BOOKS_URL}/books/${payload.id}`, payload)
}

export function getBook(id) {
  // return axios.get(`${process.env.BOOKS_URL}/books/${id}`)
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve({
        title: 'some awesome title',
        author: 'some awesome author',
        description: 'some awesome description',
        isbn: '111-22-33333-44-5',
        changelog: [
          {
            title: 'some awesome title update',
            author: 'some awesome author update',
            description: 'some awesome description update',
            isbn: '111-22-33333-44-6'
          }
        ]
      })
      // reject(new Error('oops something wrong...'))
    }, 1000)
  })
}

export function getBooks() {
  // return axios.get(`${process.env.BOOKS_URL}/books`)
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve([
        {
          id: 'asb123',
          title: 'some awesome title',
          author: 'some awesome author',
          description: 'some awesome description some awesome description some awesome description',
          isbn: '111-22-33333-44-5',
          changelog: [
            {
              title: 'title update',
              author: 'author update',
              description: 'description update',
              isbn: '111-22-33333-44-8',
            },
            {
              title: 'title update 2',
              author: 'author update 2',
              description: 'description update 2',
              isbn: '111-22-33333-44-8',
            },
            {
              title: 'title update 3',
              author: 'author update 3',
              description: 'description update 3',
              isbn: '111-22-33333-44-8',
            }
          ]
        },
        {
          id: 'asb124',
          title: 'some awesome title 2',
          author: 'some awesome author 2',
          description: 'some awesome description 2',
          isbn: '111-22-33333-44-6',
          changelog: [
            {
              title: 'title update',
              author: 'author update',
              description: 'description update',
              isbn: '111-22-33333-44-8',
            },
            {
              title: 'title update 2',
              author: 'author update 2',
              description: 'description update 2',
              isbn: '111-22-33333-44-8',
            }
          ]
        }
      ])
    }, 1000)
  })
}

export function getBookReports(id) {
  return axios.get(`${process.env.BOOKS_URL}/books/report`)
}
