Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5725E189B8F
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410860; cv=none; b=gpGhn8HIsYeuxpXizPoKVs8CEh8azyuPLsgcpH5dom6Kql8z/373nMXsQ+tufjYNTmiRc6xlyka+jXZSbeoqD56juAwfRoIYZVMQWe/sc40bRc8mlpOE2WG/0Dc1t0/GWQNPoKpfvNK8SXVe1BpSQFImgQZBFFxaUnZ3na14cyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410860; c=relaxed/simple;
	bh=vQSla8b7VYClHSRLvRBhxsiKRGIlu/7rj3sREYVa+c8=;
	h=Date:To:From:Subject:Message-Id; b=r8Tot+n+hWCcNW8GhC50OzI69C3VpdUd1p+GrOyMQ4FVn3t+gOKpqfTw+9L2inPcj/qVaYifAXxJjP3hgD6QoIsQ9EhpQMqwqe7YadNXOFedcGinnx94ZiGG5FuFvUR1+rb2Be+5EviKK+NM7CNPbmFqitI1bMTyS8Ep8EYmuVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qg7T7EZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qg7T7EZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF680C4CED3;
	Sat,  1 Feb 2025 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410859;
	bh=vQSla8b7VYClHSRLvRBhxsiKRGIlu/7rj3sREYVa+c8=;
	h=Date:To:From:Subject:From;
	b=Qg7T7EZZeTu0jX+lmF2qO0zPcnzrqtwDUxRG0qt9MP5Fqvtm8kAHlCGCIjSsPTYrg
	 ze2zu9xJvo+LA3S7lW4ydsA11bzqkXx+9UK5/bHcACbWHqbTt5HbJYqD56m9RZyHio
	 C53oLIjz5ynA2oWjMecl8Xto1z0vP7lIesqxLfms=
Date: Sat, 01 Feb 2025 03:54:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,corbet@lwn.net,bilbao@vt.edu,carlos.bilbao@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-maintainers-docs-update-my-email-address.patch removed from -mm tree
Message-Id: <20250201115419.BF680C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap, MAINTAINERS, docs: update Carlos's email address
has been removed from the -mm tree.  Its filename was
     mailmap-maintainers-docs-update-my-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Bilbao <carlos.bilbao@kernel.org>
Subject: mailmap, MAINTAINERS, docs: update Carlos's email address
Date: Wed, 29 Jan 2025 19:22:44 -0600

Update .mailmap to reflect my new (and final) primary email address,
carlos.bilbao@kernel.org.  Also update contact information in files
Documentation/translations/sp_SP/index.rst and MAINTAINERS.

Link: https://lkml.kernel.org/r/20250130012248.1196208-1-carlos.bilbao@kernel.org
Signed-off-by: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Carlos Bilbao <bilbao@vt.edu>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mattew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                   |    4 +++-
 Documentation/translations/sp_SP/index.rst |    2 +-
 MAINTAINERS                                |    8 ++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/Documentation/translations/sp_SP/index.rst~mailmap-maintainers-docs-update-my-email-address
+++ a/Documentation/translations/sp_SP/index.rst
@@ -7,7 +7,7 @@ Traducción al español
 
 	\kerneldocCJKoff
 
-:maintainer: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+:maintainer: Carlos Bilbao <carlos.bilbao@kernel.org>
 
 .. _sp_disclaimer:
 
--- a/.mailmap~mailmap-maintainers-docs-update-my-email-address
+++ a/.mailmap
@@ -148,7 +148,9 @@ Bryan Tan <bryan-bt.tan@broadcom.com> <b
 Cai Huoqing <cai.huoqing@linux.dev> <caihuoqing@baidu.com>
 Can Guo <quic_cang@quicinc.com> <cang@codeaurora.org>
 Carl Huang <quic_cjhuang@quicinc.com> <cjhuang@codeaurora.org>
-Carlos Bilbao <carlos.bilbao.osdev@gmail.com> <carlos.bilbao@amd.com>
+Carlos Bilbao <carlos.bilbao@kernel.org> <carlos.bilbao@amd.com>
+Carlos Bilbao <carlos.bilbao@kernel.org> <carlos.bilbao.osdev@gmail.com>
+Carlos Bilbao <carlos.bilbao@kernel.org> <bilbao@vt.edu>
 Changbin Du <changbin.du@intel.com> <changbin.du@gmail.com>
 Changbin Du <changbin.du@intel.com> <changbin.du@intel.com>
 Chao Yu <chao@kernel.org> <chao2.yu@samsung.com>
--- a/MAINTAINERS~mailmap-maintainers-docs-update-my-email-address
+++ a/MAINTAINERS
@@ -1090,7 +1090,7 @@ F:	drivers/video/fbdev/geode/
 
 AMD HSMP DRIVER
 M:	Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>
-R:	Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+R:	Carlos Bilbao <carlos.bilbao@kernel.org>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	Documentation/arch/x86/amd_hsmp.rst
@@ -5856,7 +5856,7 @@ F:	drivers/usb/atm/cxacru.c
 
 CONFIDENTIAL COMPUTING THREAT MODEL FOR X86 VIRTUALIZATION (SNP/TDX)
 M:	Elena Reshetova <elena.reshetova@intel.com>
-M:	Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+M:	Carlos Bilbao <carlos.bilbao@kernel.org>
 S:	Maintained
 F:	Documentation/security/snp-tdx-threat-model.rst
 
@@ -11323,7 +11323,7 @@ S:	Orphan
 F:	drivers/video/fbdev/imsttfb.c
 
 INDEX OF FURTHER KERNEL DOCUMENTATION
-M:	Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+M:	Carlos Bilbao <carlos.bilbao@kernel.org>
 S:	Maintained
 F:	Documentation/process/kernel-docs.rst
 
@@ -22205,7 +22205,7 @@ Q:	http://patchwork.linuxtv.org/project/
 F:	drivers/media/dvb-frontends/sp2*
 
 SPANISH DOCUMENTATION
-M:	Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+M:	Carlos Bilbao <carlos.bilbao@kernel.org>
 R:	Avadhut Naik <avadhut.naik@amd.com>
 S:	Maintained
 F:	Documentation/translations/sp_SP/
_

Patches currently in -mm which might be from carlos.bilbao@kernel.org are

mailmap-remove-redundant-mappings-of-emails.patch

