From: akpm@linux-foundation.org
Subject: + maintainers-add-cxacru-website-mailing-list.patch added to -mm tree
Date: Wed, 02 May 2007 23:05:02 -0700
Message-ID: <200705030605.l43652Vg005996@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbXECGFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 02:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@fire.lp0.eu, duncan.sands@math.u-psud.fr


The patch titled
     MAINTAINERS: Add cxacru website/mailing list
has been added to the -mm tree.  Its filename is
     maintainers-add-cxacru-website-mailing-list.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1027,6 +1027,8 @@ S:	Maintained
 CONEXANT ACCESSRUNNER USB DRIVER
 P:	Simon Arlott
 M:	cxacru@fire.lp0.eu
+L:	accessrunner-general@lists.sourceforge.net
+W:	http://accessrunner.sourceforge.net/
 S:	Maintained
 
 COSA/SRP SYNC SERIAL DRIVER
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

origin.patch
cxacru-add-documentation-file.patch
cxacru-cleanup-sysfs-attribute-code.patch
cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind.patch
maintainers-add-cxacru-website-mailing-list.patch
