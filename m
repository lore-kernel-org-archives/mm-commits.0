From: akpm@linux-foundation.org
Subject: + maintainers-copy-virtio-on-balloon_compactionc.patch added to
 -mm tree
Date: Thu, 03 Aug 2017 15:45:42 -0700
Message-ID: <5983a796.Bm0yninviUH7ZYuE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbdHCWpm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2017 18:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, aquini@redhat.com, wei.w.wang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: copy virtio on balloon_compaction.c
has been added to the -mm tree.  Its filename is
     maintainers-copy-virtio-on-balloon_compactionc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-copy-virtio-on-balloon_compactionc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-copy-virtio-on-balloon_compactionc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mst@redhat.com are

maintainers-copy-virtio-on-balloon_compactionc.patch

