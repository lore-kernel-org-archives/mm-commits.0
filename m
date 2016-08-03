From: akpm@linux-foundation.org
Subject: [merged] maintainers-befs-add-new-maintainers.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 11:11:28 -0700
Message-ID: <57a233d0.bLNze8N2H6kmwAu/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbcHCSN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, gregkh@linuxfoundation.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: befs: add new maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-befs-add-new-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: MAINTAINERS: befs: add new maintainers

Salah Triki and Luis de Bethencourt are taking over maintainership of befs.

Link: http://lkml.kernel.org/r/1469651079-32455-1-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-befs-add-new-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-befs-add-new-maintainers
+++ a/MAINTAINERS
@@ -2346,7 +2346,10 @@ S:	Supported
 F:	drivers/media/platform/sti/bdisp
 
 BEFS FILE SYSTEM
-S:	Orphan
+M:	Luis de Bethencourt <luisbg@osg.samsung.com>
+M:	Salah Triki <salah.triki@gmail.com>
+S:	Maintained
+T:	git git://github.com/luisbg/linux-befs.git
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
 
_

Patches currently in -mm which might be from luisbg@osg.samsung.com are


