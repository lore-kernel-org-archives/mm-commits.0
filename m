From: akpm@linux-foundation.org
Subject: + maintainers-virtio-dev-is-subscribers-only.patch added to -mm
 tree
Date: Tue, 11 Mar 2014 14:13:30 -0700
Message-ID: <531f7c7a.+sZ7kaFQy3j84LsA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbaCKVNb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 17:13:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, rdunlap@infradead.org

Subject: + maintainers-virtio-dev-is-subscribers-only.patch added to -mm tree
To: rdunlap@infradead.org,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 14:13:30 -0700


The patch titled
     Subject: MAINTAINERS: virtio-dev is subscribers only
has been added to the -mm tree.  Its filename is
     maintainers-virtio-dev-is-subscribers-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-virtio-dev-is-subscribers-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-virtio-dev-is-subscribers-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: virtio-dev is subscribers only

virtio-dev mailing list is for subscribers only according to the
returned message after trying to send to it.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-virtio-dev-is-subscribers-only MAINTAINERS
--- a/MAINTAINERS~maintainers-virtio-dev-is-subscribers-only
+++ a/MAINTAINERS
@@ -9384,7 +9384,7 @@ F:	include/media/videobuf2-*
 
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
-L:	virtio-dev@lists.oasis-open.org
+L:	virtio-dev@lists.oasis-open.org (subscribers-only)
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/char/virtio_console.c
@@ -9394,7 +9394,7 @@ F:	include/uapi/linux/virtio_console.h
 VIRTIO CORE, NET AND BLOCK DRIVERS
 M:	Rusty Russell <rusty@rustcorp.com.au>
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-L:	virtio-dev@lists.oasis-open.org
+L:	virtio-dev@lists.oasis-open.org (subscribers-only)
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/virtio/
@@ -9407,7 +9407,7 @@ F:	include/uapi/linux/virtio_*.h
 VIRTIO HOST (VHOST)
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
-L:	virtio-dev@lists.oasis-open.org
+L:	virtio-dev@lists.oasis-open.org (subscribers-only)
 L:	virtualization@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from rdunlap@infradead.org are

sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
submittingpatches-add-recommendation-for-mailing-list-references.patch
submittingpatches-document-the-use-of-git.patch
maintainers-virtio-dev-is-subscribers-only.patch
idr-remove-dead-code-v2.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

