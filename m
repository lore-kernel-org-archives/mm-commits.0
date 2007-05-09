From: akpm@linux-foundation.org
Subject: - maintainers-add-cxacru-website-mailing-list.patch removed from -mm tree
Date: Wed, 09 May 2007 14:55:20 -0700
Message-ID: <200705092155.l49LtK9J003261@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759509AbXEIV4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, duncan.sands@math.u-psud.fr, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: Add cxacru website/mailing list
has been removed from the -mm tree.  Its filename was
     maintainers-add-cxacru-website-mailing-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MAINTAINERS: Add cxacru website/mailing list
From: Simon Arlott <simon@fire.lp0.eu>

I've not made any contact with the developers of the sourceforge project,
but it would be useful for users to able to find the mailing list and the
website for firmware information even if the driver page is very out of
date right now.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Acked-by: Duncan Sands <duncan.sands@math.u-psud.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-cxacru-website-mailing-list MAINTAINERS
--- a/MAINTAINERS~maintainers-add-cxacru-website-mailing-list
+++ a/MAINTAINERS
@@ -1038,6 +1038,8 @@ S:	Maintained
 CONEXANT ACCESSRUNNER USB DRIVER
 P:	Simon Arlott
 M:	cxacru@fire.lp0.eu
+L:	accessrunner-general@lists.sourceforge.net
+W:	http://accessrunner.sourceforge.net/
 S:	Maintained
 
 CORETEMP HARDWARE MONITORING DRIVER
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

origin.patch
git-dvb.patch
cxacru-add-documentation-file.patch
cxacru-cleanup-sysfs-attribute-code.patch
cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind.patch
cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch
