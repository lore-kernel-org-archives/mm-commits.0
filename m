Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55211E22E6
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728506662; cv=none; b=b7fL04AdUGahwNRC+toozRTx8aYKAoCZWG9HiX7FFJqCvrX5FtcpUMQabaIc/ofDbyhPKEpz+2y7GkcKb3gHyWlrjNgiR5lDgNBcfgPRvCCG4Js62YhMP1V8cdmC1EABX8sSIMeSb+nczBLYeFiQgQjaEvieJOQKvw055VSKRqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728506662; c=relaxed/simple;
	bh=4QG8+EjoMdAnt2g0kq/HsZDrhXMjcnOQCvuWTK9m+v0=;
	h=Date:To:From:Subject:Message-Id; b=JExWl9gPj+C9VsKyTVlWF5xdBlXHbiTfojEY73apZm8oC0gfOYwRsoKjuCj8tmyIbk7E9Yj5C02Dm11RJ4YQnbGhzQerIhgTxT+F6EzpPp59nXxlrYzhvYy/URUfCXjdmHI/Z2VDkxlNs0xkyXa4TSsxq9ateggH43dzz3KlLto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bigezp8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bigezp8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B448C4CEC3;
	Wed,  9 Oct 2024 20:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728506662;
	bh=4QG8+EjoMdAnt2g0kq/HsZDrhXMjcnOQCvuWTK9m+v0=;
	h=Date:To:From:Subject:From;
	b=Bigezp8jl+GsZsMNvAEJkD9u78Aum2dkPPDDPsj87ni9WOOq0s51QR1THm8Y0Elsc
	 mDoHkpsjsktNcTbMM1HXrgq5U1IU6aBB3ce0cyPcISKqGbYJ3RNvyHp4cSOgMqDapF
	 sROSf6CbrcLtu8RyAb42YIiEhgSVbDWGdva6KFqA=
Date: Wed, 09 Oct 2024 13:44:21 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,leonchien@synology.com,greentime.hu@sifive.com,andybnac@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-an-entry-for-andy-chiu.patch added to mm-hotfixes-unstable branch
Message-Id: <20241009204422.0B448C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add an entry for Andy Chiu
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-an-entry-for-andy-chiu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-an-entry-for-andy-chiu.patch

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
From: Andy Chiu <andybnac@gmail.com>
Subject: mailmap: add an entry for Andy Chiu
Date: Wed, 9 Oct 2024 22:49:34 +0800

Map my outdated addresses within mailmap.

Link: https://lkml.kernel.org/r/20241009144934.43027-1-andybnac@gmail.com
Signed-off-by: Andy Chiu <andybnac@gmail.com>
Cc: Greentime Hu <greentime.hu@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Leon Chien <leonchien@synology.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-an-entry-for-andy-chiu
+++ a/.mailmap
@@ -73,6 +73,8 @@ Andrey Ryabinin <ryabinin.a.a@gmail.com>
 Andrzej Hajda <andrzej.hajda@intel.com> <a.hajda@samsung.com>
 André Almeida <andrealmeid@igalia.com> <andrealmeid@collabora.com>
 Andy Adamson <andros@citi.umich.edu>
+Andy Chiu <andybnac@gmail.com> <andy.chiu@sifive.com>
+Andy Chiu <andybnac@gmail.com> <taochiu@synology.com>
 Andy Shevchenko <andy@kernel.org> <andy@smile.org.ua>
 Andy Shevchenko <andy@kernel.org> <ext-andriy.shevchenko@nokia.com>
 Anilkumar Kolli <quic_akolli@quicinc.com> <akolli@codeaurora.org>
_

Patches currently in -mm which might be from andybnac@gmail.com are

mailmap-add-an-entry-for-andy-chiu.patch

