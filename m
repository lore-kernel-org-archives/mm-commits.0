From: akpm@linux-foundation.org
Subject: + fault-injection-add-entry-to-maintainers.patch added to -mm tree
Date: Sun, 22 Apr 2007 17:31:26 -0700
Message-ID: <200704230031.l3N0VQS2004166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030307AbXDWAb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 20:31:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fault injection: add entry to MAINTAINERS
has been added to the -mm tree.  Its filename is
     fault-injection-add-entry-to-maintainers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fault injection: add entry to MAINTAINERS
From: Akinobu Mita <akinobu.mita@gmail.com>

Add maintainer for fault injection support.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~fault-injection-add-entry-to-maintainers MAINTAINERS
--- a/MAINTAINERS~fault-injection-add-entry-to-maintainers
+++ a/MAINTAINERS
@@ -1355,6 +1355,11 @@ M:	kevin.curtis@farsite.co.uk
 W:	http://www.farsite.co.uk/
 S:	Supported
 
+FAULT INJECTION SUPPORT
+P:	Akinobu Mita
+M:	akinobu.mita@gmail.com
+S:	Supported
+
 FRAMEBUFFER LAYER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fault-injection-add-entry-to-maintainers.patch
mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch
git-dvb.patch
git-ieee1394.patch
git-net.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
slob-handle-slab_panic-flag.patch
use-slab_panic-flag-cleanup.patch
fault-injection-fix-failslab-with-config_numa.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
dtlk-fix-error-checks-in-module_init-fix.patch
