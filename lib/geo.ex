defmodule Geo do
  # Circle shapes drawn using https://www.calcmaps.com/map-radius/

  @type latitude :: float()
  @type longitude :: float()
  @type continent :: :europe | :northamerica | :africa | :australia | :asia | :other

  @spec isCoordinatesInArea?(latitude, longitude, Geocalc.Shape.Circle.t()) :: boolean
  defp isCoordinatesInArea?(lat, lon, area) do
    point = %{lat: lat, lng: lon}
    Geocalc.in_area?(area, point)
  end

  # Europe
  # Radius: 2181215 m | 2181.21 km | 1355.34 mi | 7156217 ft | 1177.76 nm
  # Circle Area: 14946750746399 m2 | 14946750.75 km2
  # Lat,Lon: 56.54461,10.91914

  # Spain and Portugal
  # Radius: 591047 m | 591.05 km | 367.26 mi | 1939130 ft | 319.14 nm
  # Circle Area: 1097472125815 m2 | 1097472.13 km2
  # Lat,Lon: 41.17816,-4.24584
  defp isInEurope(latitude, longitude) do
    europe = %Geocalc.Shape.Circle{
      latitude: 56.54461,
      longitude: 10.91914,
      radius: 2_181_215
    }

    spainAndPortugal = %Geocalc.Shape.Circle{
      latitude: 41.17816,
      longitude: -4.24584,
      radius: 591_047
    }

    isCoordinatesInArea?(latitude, longitude, europe) ||
      isCoordinatesInArea?(latitude, longitude, spainAndPortugal)
  end

  # North America
  # Radius: 4339075 m | 4339.07 km | 2696.18 mi | 14235809 ft | 2342.91 nm
  # Circle Area: 59148550160090 m2 | 59148550.16 km2
  # Lat,Lon: 43.58039,-108.28788
  defp isInNorthAmerica(latitude, longitude) do
    northAmerica = %Geocalc.Shape.Circle{
      latitude: 43.58039,
      longitude: -108.28788,
      radius: 4_339_075
    }

    isCoordinatesInArea?(latitude, longitude, northAmerica)
  end

  # Africa
  # Radius: 4288616 m | 4288.62 km | 2664.82 mi | 14070261 ft | 2315.67 nm
  # Circle Area: 57780874169219 m2 | 57780874.17 km2
  # Lat,Lon: -0.35156,9.14677

  defp isInAfrica(latitude, longitude) do
    africa = %Geocalc.Shape.Circle{
      latitude: -0.35156,
      longitude: 9.14677,
      radius: 4_288_616
    }

    isCoordinatesInArea?(latitude, longitude, africa)
  end

  # Asia
  # Radius: 5255297 m | 5255.30 km | 3265.49 mi | 17241790 ft | 2837.63 nm
  # Circle Area: 86764979261076 m2 | 86764979.26 km2
  # Lat,Lon: 34.30714,96.69073
  defp isInAsia(latitude, longitude) do
    asia = %Geocalc.Shape.Circle{
      latitude: 34.30714,
      longitude: 96.69073,
      radius: 5_255_297
    }

    isCoordinatesInArea?(latitude, longitude, asia)
  end

  # Australia
  # Radius: 3230549 m | 3230.55 km | 2007.37 mi | 10598913 ft | 1744.36 nm
  # Circle Area: 32787058546523 m2 | 32787058.55 km2
  # Lat,Lon: -25.89887,146.40949
  defp isInAustralia(latitude, longitude) do
    australia = %Geocalc.Shape.Circle{
      latitude: -25.89887,
      longitude: 146.40949,
      radius: 3_230_549
    }

    isCoordinatesInArea?(latitude, longitude, australia)
  end

  @doc ~S"""

    Return the continent associated to the given job

    ## Examples

      # Melbourne
      iex> Geo.getContinent(-37.814479, 144.965794)
      :australia

      # Paris
      iex> Geo.getContinent(48.8588897, 2.320041)
      :europe

      # Lisbonne
      iex> Geo.getContinent(38.6979940, -9.1265504)
      :europe

      # Moscou
      iex> Geo.getContinent(55.7504461, 37.6174943)
      :europe

      # Moscou
      iex> Geo.getContinent(55.7504461, 37.6174943)
      :europe

      # Pekin
      iex> Geo.getContinent(39.8919532, 116.4442401)
      :asia

      # Le Caire
      iex> Geo.getContinent(30.0443879, 31.2357257)
      :africa

      # New York
      iex> Geo.getContinent(40.7127281, -74.0060152)
      :northamerica

      # Other (pacific ocean)
      iex> Geo.getContinent(42.7341014, -175.879978)
      :other

  """
  @spec getContinent(latitude(), longitude()) :: continent
  def getContinent(latitude, longitude) do
    cond do
      isInEurope(latitude, longitude) -> :europe
      isInNorthAmerica(latitude, longitude) -> :northamerica
      isInAfrica(latitude, longitude) -> :africa
      isInAsia(latitude, longitude) -> :asia
      isInAustralia(latitude, longitude) -> :australia
      true -> :other
    end
  end
end
