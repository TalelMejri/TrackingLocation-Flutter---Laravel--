<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;

class TrackingLocation implements ShouldBroadcastNow
{
    use SerializesModels;

    private $notif;

    public function __construct($notif)
    {
        $this->notif = $notif;
    }

    public function broadcastWith()
    {
        return ['message' => $this->notif];
    }

    public function broadcastOn()
    {
        return new Channel('public');
    }
}
