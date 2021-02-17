import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withRouter } from 'react-router-dom'
import { Form, withFormik } from 'formik'
import { createBook, updateBook } from '../../api/book'
import FormControl from '../Common/FormControl/FormControl'
import Input from '../Common/Input/Input'
import Button from '../Common/Button/Button'
import FormError from '../Common/FormError/FormError'
import { bookSchema } from './BookForm.schema'
import css from './BookForm.module.scss'

export class BookFormInner extends Component {
  cancel = (e) => {
    e.preventDefault()
    e.stopPropagation()
    this.props.history.push('/')
  }

  render() {
    const {
      dirty,
      errors,
      touched,
      isSubmitting,
      handleSubmit,
      status,
      book,
    } = this.props

    const hasErrors = !!Object.keys(errors).length

    return (
      <Form onSubmit={handleSubmit}>
        <FormControl label="Author" htmlFor="author">
          <Input
            disabled={book && book.id}
            type="text"
            name="author"
            id="author"
            placeholder="author"
            error={touched.author && errors.author}
          />
        </FormControl>

        <FormControl label="Title" htmlFor="title">
          <Input
            type="text"
            name="title"
            id="title"
            placeholder="title"
            error={touched.title && errors.title}
          />
        </FormControl>

        <FormControl label="Description" htmlFor="desciption">
          <Input
            type="text"
            name="description"
            id="description"
            placeholder="description"
            error={touched.description && errors.description}
          />
        </FormControl>

        <FormControl label="ISBN" htmlFor="isbn">
          <Input
            type="text"
            name="isbn"
            id="isbn"
            placeholder="xxx-xx-xxxxx-xx-x"
            error={touched.isbn && errors.isbn}
          />
        </FormControl>

        {status.submitError && (
          <FormError>
            {status.submitError}
          </FormError>
        )}

        <div className={css.ctaContainer}>
          <Button
            kind="success"
            type="submit"
            disabled={hasErrors || isSubmitting || !dirty}
          >
            {book && book.title ? 'Update' : 'Create'}
          </Button>
          <Button
            type="button"
            kind="danger"
            onClick={this.cancel}
          >
            Cancel
          </Button>
        </div>
      </Form>
    )
  }
}

BookFormInner.propTypes = {
  errors: PropTypes.shape({
    title: PropTypes.string,
    author: PropTypes.string,
    description: PropTypes.string,
    isbn: PropTypes.string,
  }).isRequired,
  status: PropTypes.shape({
    submitError: PropTypes.string,
  }),
  touched: PropTypes.shape({
    title: PropTypes.bool,
    author: PropTypes.bool,
    description: PropTypes.bool,
    isbn: PropTypes.bool,
  }).isRequired,
  match: PropTypes.shape({
    params: PropTypes.shape({
      merchantId: PropTypes.string,
    }),
  }).isRequired,
  isSubmitting: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape({
    goBack: PropTypes.func,
  }).isRequired,
  location: PropTypes.shape({
    book: PropTypes.shape({})
  })
}

BookFormInner.defaultProps = {
  status: {},
  location: {
    book: null
  }
}

const BookForm = withFormik({
  mapPropsToValues: (props) => ({
    ...(props.location.book && props.location.book.id  ? props.location.book : props.book)
  }),

  validationSchema: bookSchema,

  handleSubmit: async (values, { setSubmitting, setStatus, props }) => {
    try {
      if (values.id) {
        await updateBook(values)
        props.history.goBack()
        return
      }

      await createBook(values)
      props.history.goBack()
    } catch (error) {
      setSubmitting(false)
      setStatus({ submitError: error.toString() })
    }
  },
})(BookFormInner)

export default withRouter(BookForm)
