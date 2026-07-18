Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525E35F603
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 20:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784405830; cv=none; b=QfPTixhjIk4aebucIvozZ0cmw0mXRQq1LCqKENG+OnjXY+a47ZgcQShkoDEqWdZ68UlRAYzRkSCcVwQx+v/GOQK0XB+xJApfZFS0MHNDoMOLQlLc6xLqQW9jJ6pilX1ear0qO55zT9UKEH5CQT1ynS9v65tnWD0rJFAo4Mty3F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784405830; c=relaxed/simple;
	bh=SGPDDn1u9AsbAWhTUXQuEdM+gReU2EM1ydoFydmw7A4=;
	h=Date:To:From:Subject:Message-Id; b=ULpDFE+3NR9d0GDiRs+fk1H5pMvOWwu7Ijpv6d7v4ibazMVNlh/7YbFofr3yr55te/jKk49JytXE0U8ZTNup5fPRju1RMyzvnHcWpcNAy93v/DSCZU7Q8qzG3UDeblDj11Dw6fs9gxPzZU0tS+92RYnydkBIh/bd4Rpp7qXdPtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yrRKhMCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yrRKhMCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792A31F000E9;
	Sat, 18 Jul 2026 20:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784405828;
	bh=Th4Idr5W/hCRIa6/6w87qWOJ/06cWohWEJlaiZ4McJc=;
	h=Date:To:From:Subject;
	b=yrRKhMCaVHRRPHAWxQdY/1OB/v2/Dk04D83BDDlLrzSwYndR/apC7a6WE3iuAGsyk
	 zHqGlSgx2PROujE2/R+u1V1bKhBBMLCOwNr1MCY4gKLf3kelvuagvS5t2LqWq8caMA
	 puy+ss36XqJIGyRK56j78FsombzoRRczaLbiUXlw=
Date: Sat, 18 Jul 2026 13:17:08 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,martink@posteo.de,kuba@kernel.org,aliceryhl@google.com,burak.emir@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-address-for-burak-emir.patch added to mm-hotfixes-unstable branch
Message-Id: <20260718201708.792A31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update address for Burak Emir
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-address-for-burak-emir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-address-for-burak-emir.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Burak Emir <burak.emir@gmail.com>
Subject: MAINTAINERS: update address for Burak Emir
Date: Sat, 18 Jul 2026 17:13:03 +0200

Update MAINTAINERS and .mailmap to point to my gmail.com address:
burak.emir@gmail.com.

Link: https://lore.kernel.org/20260718151303.2649-1-burak.emir@gmail.com
Signed-off-by: Burak Emir <burak.emir@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-address-for-burak-emir
+++ a/.mailmap
@@ -171,6 +171,7 @@ Brian Cain <bcain@kernel.org> <bcain@qui
 Brian King <brking@us.ibm.com>
 Brian Silverman <bsilver16384@gmail.com> <brian.silverman@bluerivertech.com>
 Bryan Tan <bryan-bt.tan@broadcom.com> <bryantan@vmware.com>
+Burak Emir <burak.emir@gmail.com> <bqe@google.com>
 Cai Huoqing <cai.huoqing@linux.dev> <caihuoqing@baidu.com>
 Casey Connolly <casey.connolly@linaro.org> <caleb.connolly@linaro.org>
 Casey Connolly <casey.connolly@linaro.org> <caleb@connolly.tech>
--- a/MAINTAINERS~maintainers-update-address-for-burak-emir
+++ a/MAINTAINERS
@@ -4634,7 +4634,7 @@ F:	rust/helpers/cpumask.c
 
 BITMAP API [RUST]
 M:	Alice Ryhl <aliceryhl@google.com>
-M:	Burak Emir <bqe@google.com>
+M:	Burak Emir <burak.emir@gmail.com>
 R:	Yury Norov <yury.norov@gmail.com>
 S:	Maintained
 F:	lib/find_bit_benchmark_rust.rs
_

Patches currently in -mm which might be from burak.emir@gmail.com are

maintainers-update-address-for-burak-emir.patch

