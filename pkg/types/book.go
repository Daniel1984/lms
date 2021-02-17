package types

import "time"

type Book struct {
	ID          string           `json:"id"`
	Author      string           `json:"author"`
	Title       string           `json:"title"`
	Description string           `json:"description"`
	ISBN        string           `json:"isbn"`
	UpdatedAt   time.Time        `json:"updated_at"`
	CreatedAt   time.Time        `json:"created_at"`
	ChangeLog   []*BookChangelog `json:"changelog,omitempty"`
}

type BookChangelog struct {
	Title       string    `json:"title"`
	Description string    `json:"description"`
	ISBN        string    `json:"isbn"`
	CreatedAt   time.Time `json:"created_at"`
}

func (b Book) Changelog() *BookChangelog {
	return &BookChangelog{
		Title:       b.Title,
		Description: b.Description,
		ISBN:        b.ISBN,
		CreatedAt:   time.Now().UTC(),
	}
}
