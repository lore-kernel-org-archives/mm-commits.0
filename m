From: akpm@linux-foundation.org
Subject: [patch 024/111] MAINTAINERS: befs: add new maintainers
Date: Tue, 02 Aug 2016 14:03:16 -0700
Message-ID: <57a10a94.jRLhb5Al1okKJ/WS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbcHBV4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:56:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, luisbg@osg.samsung.com, gregkh@linuxfoundation.org, tytso@mit.edu

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
