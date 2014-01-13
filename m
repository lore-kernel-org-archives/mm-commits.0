From: akpm@linux-foundation.org
Subject: + maintainers-add-virtio-dev-ml-for-virtio.patch added to -mm
 tree
Date: Mon, 13 Jan 2014 12:03:13 -0800
Message-ID: <52d44681.CwtDPE05QZSyONmV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaAMUDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 15:03:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, greg@kroah.com, mst@redhat.com

Subject: + maintainers-add-virtio-dev-ml-for-virtio.patch added to -mm tree
To: mst@redhat.com,greg@kroah.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 12:03:13 -0800


The patch titled
     Subject: MAINTAINERS: add virtio-dev ML for virtio
has been added to the -mm tree.  Its filename is
     maintainers-add-virtio-dev-ml-for-virtio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-virtio-dev-ml-for-virtio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-virtio-dev-ml-for-virtio.patch

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

origin.patch
maintainers-add-virtio-dev-ml-for-virtio.patch
linux-next.patch

