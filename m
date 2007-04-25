From: akpm@linux-foundation.org
Subject: - fault-injection-add-entry-to-maintainers.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:13 -0700
Message-ID: <200704252039.l3PKdDPA012286@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993124AbXDYUje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault injection: add entry to MAINTAINERS
has been removed from the -mm tree.  Its filename was
     fault-injection-add-entry-to-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch
git-dvb.patch
git-ieee1394.patch
git-net.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
slob-handle-slab_panic-flag.patch
use-slab_panic-flag-cleanup.patch
fault-injection-fix-failslab-with-config_numa.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
dtlk-fix-error-checks-in-module_init-fix.patch
