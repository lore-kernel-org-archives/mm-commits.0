From: akpm@linux-foundation.org
Subject: + virtio_9ph-include-linux-typesh.patch added to -mm tree
Date: Thu, 29 Apr 2010 16:25:53 -0700
Message-ID: <201004292325.o3TNPrZX017548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758524Ab0D3RI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:08:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ericvh@gmail.com


The patch titled
     virtio_9p.h: include linux/types.h
has been added to the -mm tree.  Its filename is
     virtio_9ph-include-linux-typesh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: virtio_9p.h: include linux/types.h
From: Randy Dunlap <randy.dunlap@oracle.com>

Add <linux/types.h> to <linux/virtio_9p.h> so that types are explicitly
defined:
linux/virtio_9p.h:15: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/virtio_9p.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/virtio_9p.h~virtio_9ph-include-linux-typesh include/linux/virtio_9p.h
--- a/include/linux/virtio_9p.h~virtio_9ph-include-linux-typesh
+++ a/include/linux/virtio_9p.h
@@ -2,6 +2,7 @@
 #define _LINUX_VIRTIO_9P_H
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
+#include <linux/types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
virtio_9ph-include-linux-typesh.patch
dib3000mc-reduce-large-stack-usage.patch
dib3000mc-reduce-large-stack-usage-fix.patch
dib7000p-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

