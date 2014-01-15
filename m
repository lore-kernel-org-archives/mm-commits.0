From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-virtio-dev-ml-for-virtio.patch removed
 from -mm tree
Date: Tue, 14 Jan 2014 17:17:59 -0800
Message-ID: <52d5e1c7.BDNXQOCLxa77awgY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOBSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 20:18:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, greg@kroah.com, mst@redhat.com

Subject: [merged] maintainers-add-virtio-dev-ml-for-virtio.patch removed from -mm tree
To: mst@redhat.com,greg@kroah.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 17:17:59 -0800


The patch titled
     Subject: MAINTAINERS: add virtio-dev ML for virtio
has been removed from the -mm tree.  Its filename was
     maintainers-add-virtio-dev-ml-for-virtio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: MAINTAINERS: add virtio-dev ML for virtio

Since virtio is an OASIS standard draft now, virtio implementation
discussions are taking place on the virtio-dev OASIS mailing list.
Update MAINTAINERS.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

diff -puN MAINTAINERS~maintainers-add-virtio-dev-ml-for-virtio MAINTAINERS
--- a/MAINTAINERS~maintainers-add-virtio-dev-ml-for-virtio
+++ a/MAINTAINERS
@@ -9242,6 +9242,7 @@ F:	include/media/videobuf2-*
 
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
+L:	virtio-dev@lists.oasis-open.org
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/char/virtio_console.c
@@ -9251,6 +9252,7 @@ F:	include/uapi/linux/virtio_console.h
 VIRTIO CORE, NET AND BLOCK DRIVERS
 M:	Rusty Russell <rusty@rustcorp.com.au>
 M:	"Michael S. Tsirkin" <mst@redhat.com>
+L:	virtio-dev@lists.oasis-open.org
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/virtio/
@@ -9263,6 +9265,7 @@ F:	include/uapi/linux/virtio_*.h
 VIRTIO HOST (VHOST)
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
+L:	virtio-dev@lists.oasis-open.org
 L:	virtualization@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from mst@redhat.com are

linux-next.patch

