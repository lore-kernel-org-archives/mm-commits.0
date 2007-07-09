From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:36:21 -0700
Message-ID: <200707092336.l69NaL5S020571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757830AbXGIXgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: vary maximum delegation limit based on RAM size (fix)
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch

This patch was dropped because it was folded into knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch

------------------------------------------------------
Subject: knfsd: nfsd4: vary maximum delegation limit based on RAM size (fix)
From: "J. Bruce Fields" <bfields@fieldses.org>

I missed a compile warning here, apologies.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix
+++ a/fs/nfsd/nfs4state.c
@@ -3199,7 +3199,7 @@ get_nfs4_grace_period(void)
 }
 
 static void
-set_max_delegations()
+set_max_delegations(void)
 {
 	struct sysinfo sys;
 
_

Patches currently in -mm which might be from bfields@fieldses.org are

rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch
git-vfs-lease-api.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch
