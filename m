From: akpm@linux-foundation.org
Subject: + add-3c59x-maintainer.patch added to -mm tree
Date: Fri, 10 Aug 2007 01:19:47 -0700
Message-ID: <200708100819.l7A8Jl5j011409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836AbXHJIT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Aug 2007 04:19:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: klassert@mathematik.tu-chemnitz.de


The patch titled
     3c59x maintainer
has been added to the -mm tree.  Its filename is
     add-3c59x-maintainer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 3c59x maintainer
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>

Add 3c59x maintainer.

Signed-off-by: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~add-3c59x-maintainer MAINTAINERS
--- a/MAINTAINERS~add-3c59x-maintainer
+++ a/MAINTAINERS
@@ -97,6 +97,12 @@ M:	philb@gnu.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+3C59X NETWORK DRIVER
+P:	Steffen Klassert
+M:	klassert@mathematik.tu-chemnitz.de
+L:	netdev@vger.kernel.org
+S:	Maintained
+
 3CR990 NETWORK DRIVER
 P:	David Dillow
 M:	dave@thedillows.org
_

Patches currently in -mm which might be from klassert@mathematik.tu-chemnitz.de are

3c59x-check-return-of-pci_enable_device.patch
3c59x-fix-duplex-configuration.patch
add-3c59x-maintainer.patch
wol-bugfix-for-3c59xc.patch
