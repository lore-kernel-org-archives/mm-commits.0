From: akpm@linux-foundation.org
Subject: + linux-audit-list-is-subscribers-only.patch added to -mm tree
Date: Wed, 01 Aug 2007 17:27:56 -0700
Message-ID: <200708020027.l720RuRx024966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbXHBA2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 20:28:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com, dwmw2@infradead.org, viro@zeniv.linux.org.uk


The patch titled
     linux-audit list is subscribers-only
has been added to the -mm tree.  Its filename is
     linux-audit-list-is-subscribers-only.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: linux-audit list is subscribers-only
From: Gabriel C <nix.or.die@googlemail.com>

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~linux-audit-list-is-subscribers-only MAINTAINERS
--- a/MAINTAINERS~linux-audit-list-is-subscribers-only
+++ a/MAINTAINERS
@@ -664,7 +664,7 @@ S:	Maintained
 AUDIT SUBSYSTEM
 P:	David Woodhouse
 M:	dwmw2@infradead.org
-L:	linux-audit@redhat.com
+L:	linux-audit@redhat.com (subscribers-only)
 W:	http://people.redhat.com/sgrubb/audit/
 T:	git kernel.org:/pub/scm/linux/kernel/git/dwmw2/audit-2.6.git
 S:	Maintained
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

origin.patch
linux-audit-list-is-subscribers-only.patch
fix-libata-warnings-with-config_pm=n.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
