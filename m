From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-chirag-kantharia-invalid-e-mail.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:21 -0700
Message-ID: <543d6929.C3Ct8xHbPw0t/k63%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaJNSTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove Chirag Kantharia, invalid e-mail
has been removed from the -mm tree.  Its filename was
     maintainers-remove-chirag-kantharia-invalid-e-mail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: MAINTAINERS: remove Chirag Kantharia, invalid e-mail

This removes Chirag Kantharia from the MAINTAINERS file, as his e-mail
address is now rejected by the HP mail server.

Make the driver "Orphan" until he gets back with a working e-mail address
or a new maintainer steps in.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-chirag-kantharia-invalid-e-mail MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-chirag-kantharia-invalid-e-mail
+++ a/MAINTAINERS
@@ -4303,9 +4303,8 @@ S:	Maintained
 F:	drivers/media/dvb-frontends/hd29l2*
 
 HEWLETT-PACKARD SMART2 RAID DRIVER
-M:	Chirag Kantharia <chirag.kantharia@hp.com>
 L:	iss_storagedev@hp.com
-S:	Maintained
+S:	Orphan
 F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

origin.patch
linux-next.patch

