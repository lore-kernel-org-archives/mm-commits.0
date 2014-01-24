From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:03 -0800
Message-ID: <52e2b86f.1i8/mv2/JJtNA01l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hch@lst.de, alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org

Subject: [merged] maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch removed from -mm tree
To: geert@linux-m68k.org,alan@lxorguk.ukuu.org.uk,hch@lst.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:03 -0800


The patch titled
     Subject: MAINTAINERS: add an entry for the Macintosh HFSPlus Filesystem
has been removed from the -mm tree.  Its filename was
     maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: MAINTAINERS: add an entry for the Macintosh HFSPlus Filesystem

To make scripts/get_maintainer.pl output something sensible.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem MAINTAINERS
--- a/MAINTAINERS~maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem
+++ a/MAINTAINERS
@@ -3955,6 +3955,12 @@ S:	Orphan
 F:	Documentation/filesystems/hfs.txt
 F:	fs/hfs/
 
+HFSPLUS FILESYSTEM
+L:	linux-fsdevel@vger.kernel.org
+S:	Orphan
+F:	Documentation/filesystems/hfsplus.txt
+F:	fs/hfsplus/
+
 HGA FRAMEBUFFER DRIVER
 M:	Ferenc Bakonyi <fero@drama.obuda.kando.hu>
 L:	linux-nvidia@lists.surfsouth.com
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch

