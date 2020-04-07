From: akpm@linux-foundation.org
Subject: [folded-merged]
 hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch removed from
 -mm tree
Date: Mon, 06 Apr 2020 18:45:21 -0700
Message-ID: <20200407014521.zD4rneJFL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgDGBpX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 21:45:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hv_balloon-dont-check-for-memhp_auto_online-manually-fix
has been removed from the -mm tree.  Its filename was
     hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch

This patch was dropped because it was folded into hv_balloon-dont-check-for-memhp_auto_online-manually.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hv_balloon-dont-check-for-memhp_auto_online-manually-fix

needs changelog ;)

Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hv/hv_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/hv_balloon.c~hv_balloon-dont-check-for-memhp_auto_online-manually-fix
+++ a/drivers/hv/hv_balloon.c
@@ -1700,8 +1700,8 @@ static int balloon_probe(struct hv_devic
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 	set_online_page_callback(&hv_online_page);
-	register_memory_notifier(&hv_memory_nb);
 	init_completion(&dm_device.ol_waitevent);
+	register_memory_notifier(&hv_memory_nb);
 #endif
 
 	hv_set_drvdata(dev, &dm_device);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hv_balloon-dont-check-for-memhp_auto_online-manually.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
