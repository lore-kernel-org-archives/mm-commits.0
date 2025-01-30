Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB46419AD8D
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 23:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280785; cv=none; b=u0ZZSZEfOjNrnSYVCQvZFnWJHPSa+s4blQyTfmUUPaKMxcj1TEQO59rvC0oZVRnc/OU6w2X0ReikKamlz01sE21Nf1nuMqcgTxngVuLtR+CGSNuRWHZuqapky7XdOsGx722Ov8OLGD+tx4U6Nl9ORiU487s3JoYhYTf50UUuvWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280785; c=relaxed/simple;
	bh=Pd5Un4Utqlx5IEh0MbRkNR5DCXueA0TrPaJRwR1bNFQ=;
	h=Date:To:From:Subject:Message-Id; b=pGhUBLMbQLsBzPkHUPaKy8cQWaJ9GxvFnf2TX5AN+qf9Hr96Hr56izKHKwT5cIv6BJnNyg+tFxa/awXTcCvGuOM9nLbMUenyLC2lofxdn21R7Z3wcKEtm++KP90Y1gPQbTnEzJebnx8VkOjd7zVVtVyMKJuf5I3P2aLdiLWyN6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UMGA3e04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UMGA3e04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E7DC4CED2;
	Thu, 30 Jan 2025 23:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738280785;
	bh=Pd5Un4Utqlx5IEh0MbRkNR5DCXueA0TrPaJRwR1bNFQ=;
	h=Date:To:From:Subject:From;
	b=UMGA3e04tYOF+RLNn/ZI2bQDoB8C//PyU+7uno29wdKrDR2qPsbKpML2Fshdxh4jr
	 6IalKmfYwKWX9GlnrmZQEYgnQtlvySlED+Zpq7zxnHLolCeFKo+3pYEPulRsCT9wlz
	 FEPpGMkwFWuEXc3h4fktLiB82g9VlHII3OmeUTV8=
Date: Thu, 30 Jan 2025 15:46:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,corbet@lwn.net,bilbao@vt.edu,carlos.bilbao@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-maintainers-docs-update-my-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20250130234625.35E7DC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap, MAINTAINERS, docs: update Carlos's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-maintainers-docs-update-my-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-maintainers-docs-update-my-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -1084,7 +1084,7 @@ F:	drivers/video/fbdev/geode/
 
 AMD HSMP DRIVER
 M:	Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>
-R:	Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+R:	Carlos Bilbao <carlos.bilbao@kernel.org>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	Documentation/arch/x86/amd_hsmp.rst
@@ -5839,7 +5839,7 @@ F:	drivers/usb/atm/cxacru.c
 
 CONFIDENTIAL COMPUTING THREAT MODEL FOR X86 VIRTUALIZATION (SNP/TDX)
 M:	Elena Reshetova <elena.reshetova@intel.com>
-M:	Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+M:	Carlos Bilbao <carlos.bilbao@kernel.org>
 S:	Maintained
 F:	Documentation/security/snp-tdx-threat-model.rst
 
@@ -11298,7 +11298,7 @@ S:	Orphan
 F:	drivers/video/fbdev/imsttfb.c
 
 INDEX OF FURTHER KERNEL DOCUMENTATION
-M:	Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+M:	Carlos Bilbao <carlos.bilbao@kernel.org>
 S:	Maintained
 F:	Documentation/process/kernel-docs.rst
 
@@ -22159,7 +22159,7 @@ Q:	http://patchwork.linuxtv.org/project/
 F:	drivers/media/dvb-frontends/sp2*
 
 SPANISH DOCUMENTATION
-M:	Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+M:	Carlos Bilbao <carlos.bilbao@kernel.org>
 R:	Avadhut Naik <avadhut.naik@amd.com>
 S:	Maintained
 F:	Documentation/translations/sp_SP/
_

Patches currently in -mm which might be from carlos.bilbao@kernel.org are

mailmap-maintainers-docs-update-my-email-address.patch
mailmap-remove-redundant-mappings-of-emails.patch

