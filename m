From: akpm@linux-foundation.org
Subject: - afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch removed from -mm tree
Date: Mon, 28 Apr 2008 23:06:04 -0700
Message-ID: <200804290606.m3T664gt004459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754221AbYD2GGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 02:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     afs: the AFS RPC op CBGetCapabilities is actually CBTellMeAboutYourself [try #3]
has been removed from the -mm tree.  Its filename was
     afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch

This patch was dropped because it was folded into afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: the AFS RPC op CBGetCapabilities is actually CBTellMeAboutYourself [try #3]
From: David Howells <dhowells@redhat.com>

The AFS RxRPC op CBGetCapabilities is actually CBTellMeAboutYourself.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/cmservice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/afs/cmservice.c~afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3 fs/afs/cmservice.c
--- a/fs/afs/cmservice.c~afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3
+++ a/fs/afs/cmservice.c
@@ -74,7 +74,7 @@ static const struct afs_call_type afs_SR
  * CB.TellMeAboutYourself operation type
  */
 static const struct afs_call_type afs_SRXCBTellMeAboutYourself = {
-	.name		= "CB.",
+	.name		= "CB.TellMeAboutYourself",
 	.deliver	= afs_deliver_cb_tell_me_about_yourself,
 	.abort_to_error	= afs_abort_to_error,
 	.destructor	= afs_cm_destructor,
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
remove-the-macro-get_personality.patch
fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for.patch
maintainers-clarify-status-of-mn10300-mailing-list-as-moderated.patch
xattr-add-missing-consts-to-function-arguments.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
afs-use-the-shorter-list_head-for-brevity.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch
afs-support-the-cbprobeuuid-rpc-op.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mutex-subsystem-synchro-test-module.patch

