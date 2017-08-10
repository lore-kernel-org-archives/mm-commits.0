From: akpm@linux-foundation.org
Subject: [patch 16/21] MAINTAINERS: copy virtio on balloon_compaction.c
Date: Thu, 10 Aug 2017 15:24:18 -0700
Message-ID: <598cdd12.4B+9ouFNI1oF9ruv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbdHJWYT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mst@redhat.com, aquini@redhat.com, wei.w.wang@intel.com

From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: MAINTAINERS: copy virtio on balloon_compaction.c

Changes to mm/balloon_compaction.c can easily break virtio, and virtio is
the only user of that interface.  Add a line to MAINTAINERS so whoever
changes that file remembers to copy us.

Link: http://lkml.kernel.org/r/1501764010-24456-1-git-send-email-mst@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-copy-virtio-on-balloon_compactionc MAINTAINERS
--- a/MAINTAINERS~maintainers-copy-virtio-on-balloon_compactionc
+++ a/MAINTAINERS
@@ -14004,6 +14004,7 @@ F:	drivers/block/virtio_blk.c
 F:	include/linux/virtio*.h
 F:	include/uapi/linux/virtio_*.h
 F:	drivers/crypto/virtio/
+F:	mm/balloon_compaction.c
 
 VIRTIO CRYPTO DRIVER
 M:	Gonglei <arei.gonglei@huawei.com>
_
