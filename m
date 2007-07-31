From: akpm@linux-foundation.org
Subject: + fix-a-typo-in-documentation-keystxt.patch added to -mm tree
Date: Mon, 30 Jul 2007 17:14:09 -0700
Message-ID: <200707310014.l6V0E9J5005749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S940186AbXGaAOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 20:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, dhowells@redhat.com


The patch titled
     Fix a typo in Documentation/keys.txt
has been added to the -mm tree.  Its filename is
     fix-a-typo-in-documentation-keystxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix a typo in Documentation/keys.txt
From: Satyam Sharma <satyam@infradead.org>

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/keys.txt |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

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

fix-a-typo-in-documentation-keystxt.patch
use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface.patch
netconsole-cleanups-codingstyle-prettyfication.patch
netconsole-remove-bogus-check.patch
netconsole-simplify-boot-module-option-setup-logic.patch
netconsole-use-netif_running-in-write_msg.patch
netconsole-add-some-useful-tips-to-documentation.patch
netconsole-introduce-netconsole_target.patch
netconsole-introduce-netconsole_netdev_notifier.patch
netconsole-support-multiple-logging-targets.patch
netconsole-support-dynamic-reconfiguration-using-configfs.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
