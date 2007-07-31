From: akpm@linux-foundation.org
Subject: - fix-a-typo-in-documentation-keystxt.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:27 -0700
Message-ID: <200707312356.l6VNuRJ2029324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761166AbXHAARH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Fix a typo in Documentation/keys.txt
has been removed from the -mm tree.  Its filename was
     fix-a-typo-in-documentation-keystxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix a typo in Documentation/keys.txt
From: Satyam Sharma <satyam@infradead.org>

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/keys.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/keys.txt~fix-a-typo-in-documentation-keystxt Documentation/keys.txt
--- a/Documentation/keys.txt~fix-a-typo-in-documentation-keystxt
+++ a/Documentation/keys.txt
@@ -859,9 +859,8 @@ payload contents" for more information.
 	void unregister_key_type(struct key_type *type);
 
 
-Under some circumstances, it may be desirable to desirable to deal with a
-bundle of keys.  The facility provides access to the keyring type for managing
-such a bundle:
+Under some circumstances, it may be desirable to deal with a bundle of keys.
+The facility provides access to the keyring type for managing such a bundle:
 
 	struct key_type key_type_keyring;
 
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
netconsole-cleanups-codingstyle-prettyfication.patch
netconsole-remove-bogus-check.patch
netconsole-simplify-boot-module-option-setup-logic.patch
netconsole-use-netif_running-in-write_msg.patch
netconsole-add-some-useful-tips-to-documentation.patch
netconsole-introduce-netconsole_target.patch
netconsole-introduce-netconsole_netdev_notifier.patch
netconsole-support-multiple-logging-targets.patch
netconsole-support-dynamic-reconfiguration-using-configfs.patch
introduce-u16_max-and-u32_max.patch
introduce-u16_max-and-u32_max-fix.patch
introduce-strtol_check_range.patch
introduce-strtol_check_range-fix.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
