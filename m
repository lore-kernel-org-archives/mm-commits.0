Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C14226160
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828697; cv=none; b=K+ihwq1yOgXd8rm6ihQlGTCcDGPVtxopZ/9kAa6VXPuF9hbp8Y48WjrZvDzSNe4/cyYCW1txn0r4/O+unDBu/hvg7JVy6n7gm65yA6P/uYsp6azz0ByI/PL/qkGWgwmi+IXS7W7DCNDEKvk8fequzIOCwe47j7YaFGoQotasxF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828697; c=relaxed/simple;
	bh=703og15RfjIETY4tABDuS5ns3qCXO2cMqrp4ScGgu0w=;
	h=Date:To:From:Subject:Message-Id; b=IqnHqvc9gASfTdKYqPm8vhxYthCATGciSPgfCnrEyBVMWNfEwYcDFQ9hsDeRnSvPaeqvGAPv2m3fC8IuA7lXeEqDALILqBg9gNBNAkNqvdN5LHk8LMhkWsrpyGmI8+46JZow6ykIthjjqcLf71eI/pPyaecE8mk8vvRH6TYKF2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=arUsUUpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="arUsUUpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97B0C4CEDD;
	Thu,  6 Feb 2025 07:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828696;
	bh=703og15RfjIETY4tABDuS5ns3qCXO2cMqrp4ScGgu0w=;
	h=Date:To:From:Subject:From;
	b=arUsUUpRKoTs8PfVC2SgN3LWgHo7o/h9of014dE3HKJbHuLFZikWtct2vZZouGNnY
	 +cudRe/ZLYKf3J1/IMdShEE3V/bRUMd1M7c+kJgvgSFeG7hqoedL22OKfHOajy1JaQ
	 eAFcCHQwnwaPkFbAgI49wKH5gqYFFMV9mcHrfSKU=
Date: Wed, 05 Feb 2025 23:58:16 -0800
To: mm-commits@vger.kernel.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-feng-tang.patch added to mm-hotfixes-unstable branch
Message-Id: <20250206075816.A97B0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Feng Tang
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-feng-tang.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-feng-tang.patch

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
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: mailmap: add entry for Feng Tang
Date: Wed, 5 Feb 2025 14:04:57 +0800

Map my old business email to personal email.

Link: https://lkml.kernel.org/r/20250205060457.53667-1-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-feng-tang
+++ a/.mailmap
@@ -224,6 +224,7 @@ Fangrui Song <i@maskray.me> <maskray@goo
 Felipe W Damasio <felipewd@terra.com.br>
 Felix Kuhling <fxkuehl@gmx.de>
 Felix Moeller <felix@derklecks.de>
+Feng Tang <feng.79.tang@gmail.com> <feng.tang@intel.com>
 Fenglin Wu <quic_fenglinw@quicinc.com> <fenglinw@codeaurora.org>
 Filipe Lautert <filipe@icewall.org>
 Finn Thain <fthain@linux-m68k.org> <fthain@telegraphics.com.au>
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

mailmap-add-entry-for-feng-tang.patch

