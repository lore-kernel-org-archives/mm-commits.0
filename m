From: akpm@linux-foundation.org
Subject: - linux-audit-list-is-subscribers-only.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:56 -0700
Message-ID: <200708140502.l7E52uDT032012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763300AbXHNFDj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nix.or.die@googlemail.com, dwmw2@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     linux-audit list is subscribers-only
has been removed from the -mm tree.  Its filename was
     linux-audit-list-is-subscribers-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kvm.patch
fix-libata-warnings-with-config_pm=n.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
