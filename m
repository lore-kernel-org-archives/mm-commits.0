From: akpm@linux-foundation.org
Subject: [merged] maintainers-nilfs2-add-header-file-for-tracing.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:18 -0800
Message-ID: <5640fe5e.bzHK+fXrobfOJNAD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mitake.hitoshi@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: nilfs2: add header file for tracing
has been removed from the -mm tree.  Its filename was
     maintainers-nilfs2-add-header-file-for-tracing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: MAINTAINERS: nilfs2: add header file for tracing

This adds header file "include/trace/events/nilfs2.h" to maintainer-ship
of nilfs2 so that updates to the nilfs2 header file go to the mailing list
of nilfs2.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-nilfs2-add-header-file-for-tracing MAINTAINERS
--- a/MAINTAINERS~maintainers-nilfs2-add-header-file-for-tracing
+++ a/MAINTAINERS
@@ -7491,6 +7491,7 @@ S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
 F:	fs/nilfs2/
 F:	include/linux/nilfs2_fs.h
+F:	include/trace/events/nilfs2.h
 
 NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 M:	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


