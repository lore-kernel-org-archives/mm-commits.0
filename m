From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-hvc-file-patterns.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:11:09 -0800
Message-ID: <201102282111.p1SLB98x029393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755247Ab1B1VLm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:11:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update HVC file patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-hvc-file-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update HVC file patterns
From: Joe Perches <joe@perches.com>

Commit 728674a7e46 ("tty: move hvc drivers to drivers/tty/hvc/") moved the
files, update the patterns as appropriate.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-hvc-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-hvc-file-patterns
+++ a/MAINTAINERS
@@ -2828,7 +2828,7 @@ F:	mm/hwpoison-inject.c
 HYPERVISOR VIRTUAL CONSOLE DRIVER
 L:	linuxppc-dev@lists.ozlabs.org
 S:	Odd Fixes
-F:	drivers/char/hvc_*
+F:	drivers/tty/hvc/
 
 iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
 M:	Peter Jones <pjones@redhat.com>
@@ -6111,7 +6111,7 @@ M:	Chris Metcalf <cmetcalf@tilera.com>
 W:	http://www.tilera.com/scm/
 S:	Supported
 F:	arch/tile/
-F:	drivers/char/hvc_tile.c
+F:	drivers/tty/hvc/hvc_tile.c
 F:	drivers/net/tile/
 
 TLAN NETWORK DRIVER
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch
printk-allow-setting-default_message_level-via-kconfig.patch
get_maintainerpl-allow-k-pattern-tests-to-match-non-patch-text.patch
maintainers-quote-non-alphanumeric-email-addresses.patch
maintainers-update-adp5520-pattern.patch
maintainers-change-web-links-from-wiki-analog-to-wikianalog.patch
maintainers-remove-asoc-codec-drivers-files-not-in-tree.patch
maintainers-add-missing-after-hr-timers-f-tag.patch
maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries.patch
maintainers-update-clkdev-location.patch
maintainers-update-media-path.patch
maintainers-remove-unused-clockeventsh.patch
maintainers-remove-ieee1394-entry.patch
maintainers-remove-unused-timekeeping-timekeepingh.patch
maintainers-update-scx200-file-pattern.patch
maintainers-remove-sharp-lh7a40x-section.patch
maintainers-update-sfi-pattern.patch
maintainers-update-tipc-patterns.patch
maintainers-usb-se401-moved-to-staging-update-pattern.patch
maintainers-update-winbond-cir-pattern.patch

