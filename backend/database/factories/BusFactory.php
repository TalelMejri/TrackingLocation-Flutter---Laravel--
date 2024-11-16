<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Bus>
 */
class BusFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition()
    {
        return [
            'name' => $this->faker->company(), // Random company name for the bus
            'latitude' => $this->faker->latitude(-90, 90), // Random latitude
            'longitude' => $this->faker->longitude(-180, 180),
        ];
    }
}
