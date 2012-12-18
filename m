From: akpm@linux-foundation.org
Subject: [merged] documentation-fixed-documentation-security-00-index.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:54 -0800
Message-ID: <20121218200854.9BDCA82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:48307 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2LRUIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:55 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so125934yen.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.sakkinen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: fix Documentation/security/00-INDEX
has been removed from the -mm tree.  Its filename was
     documentation-fixed-documentation-security-00-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Documentation: fix Documentation/security/00-INDEX

keys-ecryptfs.txt was missing from 00-INDEX.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/security/00-INDEX |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/security/00-INDEX~documentation-fixed-documentation-security-00-index Documentation/security/00-INDEX
--- a/Documentation/security/00-INDEX~documentation-fixed-documentation-security-00-index
+++ a/Documentation/security/00-INDEX
@@ -12,6 +12,8 @@ apparmor.txt
 	- documentation on the AppArmor security extension.
 credentials.txt
 	- documentation about credentials in Linux.
+keys-ecryptfs.txt
+	- description of the encryption keys for the ecryptfs filesystem.
 keys-request-key.txt
 	- description of the kernel key request service.
 keys-trusted-encrypted.txt
_

Patches currently in -mm which might be from jarkko.sakkinen@intel.com are

origin.patch

