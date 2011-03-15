From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-tipc-patterns.patch removed from -mm tree
Date: Tue, 15 Mar 2011 13:30:18 -0700
Message-ID: <201103152032.p2FKWSiF009731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758561Ab1COUck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 16:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, allan.stephens@windriver.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update TIPC patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-tipc-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update TIPC patterns
From: Joe Perches <joe@perches.com>

commit d265fef6ddf ("tipc: Remove obsolete native API files and exports")
removed the files, remove the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Allan Stephens <allan.stephens@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-tipc-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-tipc-patterns
+++ a/MAINTAINERS
@@ -6100,7 +6100,6 @@ W:	http://tipc.cslab.ericsson.net/
 T:	git git://tipc.cslab.ericsson.net/pub/git/tipc.git
 S:	Maintained
 F:	include/linux/tipc*.h
-F:	include/net/tipc/
 F:	net/tipc/
 
 TILE ARCHITECTURE
_

Patches currently in -mm which might be from joe@perches.com are

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
maintainers-remove-ieee1394-entry.patch
maintainers-remove-unused-timekeeping-timekeepingh.patch
maintainers-update-scx200-file-pattern.patch
maintainers-remove-sharp-lh7a40x-section.patch
maintainers-update-sfi-pattern.patch
maintainers-usb-se401-moved-to-staging-update-pattern.patch
maintainers-update-winbond-cir-pattern.patch

