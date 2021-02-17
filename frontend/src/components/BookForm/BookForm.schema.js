import * as Yup from 'yup'

export const bookSchema = Yup.object().shape({
  title: Yup
    .string()
    .required('is required'),
  author: Yup
    .string()
    .required('is required'),
  description: Yup
    .string()
    .required('is required'),
  isbn: Yup
    .string()
    .required('is required')
    .matches(/^\d{3}(-| )\d{2}(-| )\d{5}(-| )\d{2}(-| )\d{1}$/gm, { message: 'follow xxx-xx-xxxxx-xx-x pattern' })
})

