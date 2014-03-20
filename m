From: akpm@linux-foundation.org
Subject: [merged] maintainers-virtio-dev-is-subscribers-only.patch removed from -mm tree
Date: Thu, 20 Mar 2014 12:42:42 -0700
Message-ID: <532b44b2.Tux+Imuv/juqe4Z5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089AbaCTTmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Mar 2014 15:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, rdunlap@infradead.org

Subject: [merged] maintainers-virtio-dev-is-subscribers-only.patch removed from -mm tree
To: rdunlap@infradead.org,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 20 Mar 2014 12:42:42 -0700


The patch titled
     Subject: MAINTAINERS: virtio-dev is subscribers only
has been removed from the -mm tree.  Its filename was
     maintainers-virtio-dev-is-subscribers-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
idr-remove-dead-code-v2.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

