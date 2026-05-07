import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { MirrorIcon } from "lucide-react";

interface ReflectionCardProps {
  id: number;
  title: string;
  type: string;
  revenue: string;
  childrenCount: number;
  isActive: boolean;
}

export function ReflectionCard({
  id,
  title,
  type,
  revenue,
  childrenCount,
  isActive,
}: ReflectionCardProps) {
  return (
    <Card className="mirror-glass border-mirror-glass p-4 hover:neon-glow transition-all">
      <div className="flex justify-between items-start mb-3">
        <div>
          <h3 className="text-lg font-semibold neon-text">{title}</h3>
          <p className="text-sm text-gray-400">#{id}</p>
        </div>
        <Badge variant={isActive ? "default" : "secondary"}>
          {isActive ? "Active" : "Inactive"}
        </Badge>
      </div>
      
      <div className="space-y-2 mb-4">
        <div className="flex justify-between text-sm">
          <span className="text-gray-400">Type</span>
          <span className="text-white">{type}</span>
        </div>
        <div className="flex justify-between text-sm">
          <span className="text-gray-400">Revenue</span>
          <span className="neon-accent">{revenue}</span>
        </div>
        <div className="flex justify-between text-sm">
          <span className="text-gray-400">Shards</span>
          <span className="text-white">{childrenCount}</span>
        </div>
      </div>
      
      <Button className="w-full bg-mirror-neon text-mirror-black hover:opacity-90">
        <MirrorIcon className="w-4 h-4 mr-2" />
        View Reflection
      </Button>
    </Card>
  );
}
