Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C30363097
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 07:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786174832; cv=none; b=JTDUQgx7i6smEiHuHpI9rO3lQa4xPoXKSb4LbwMoyBWmgL5g0CJGJAkrqi5oTVgMkdrvdIcQM1Qv6yJuggsicRYwhI5DkzpkmY+J0dG8Iu4rcrdrvx/C1BRP4Epi4OAmxlow+rp4Jbl+mhPZG/ZHBrKBRFdJpPj9WBR06fjzXl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786174832; c=relaxed/simple;
	bh=n0MxbJ7kQ3vYZa6upqy8qrZMZ4sNv47vHvk5QZ5E4Lo=;
	h=Date:To:From:Subject:Message-Id; b=gOOM2N+IrQdTawJ7vT+zFTQpX3Cp9+uL3+wKhD3yKIB8Urgntqd0erVC3sQ71srKUa8WKpgakoQL33arqVMH0FLzplOSVSKISlFW1kQDP/WmYV6BEX3g0K/Z+LISBq2WSjL1PNTF8fgfXs7ytEZpSGomFmGSGqwdPfyweomMutw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r0C4aZiI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r0C4aZiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5A51F000E9;
	Sat,  8 Aug 2026 07:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786174829;
	bh=Jvtaj5EyMITfjbOSDYQxB1Rng3L0wYgHdpvdGS/lL9E=;
	h=Date:To:From:Subject;
	b=r0C4aZiISaFZhga2VXNIwBwjRk8YPQH9aNwCOt5iu3WPKEuvIYXYyRKA38LsAZYgk
	 tWINtmdMhkmK4JSEQM/ahQZI+I6nGNIKaw6m6zZ1gtDZ1VKExXfGfQPnpEJjNnXStd
	 JGOPpBNwFIr3LHNy+K6hbd361DQjvHuWNgbHcOF0=
Date: Sat, 08 Aug 2026 00:40:29 -0700
To: mm-commits@vger.kernel.org,docular.xu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-guodong-xu.patch added to mm-hotfixes-unstable branch
Message-Id: <20260808074029.AC5A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entries for Guodong Xu
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-guodong-xu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-guodong-xu.patch

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
From: Guodong Xu <docular.xu@gmail.com>
Subject: mailmap: add entries for Guodong Xu
Date: Fri, 07 Aug 2026 18:12:34 -0400

Map my old Linaro and RISCstar email addresses to my current personal
address.  Neither former address receives mail anymore.

Link: https://lore.kernel.org/20260807-b4-mailmap-guodong-xu-v2-1-f7c71bc6bd9f@gmail.com
Signed-off-by: Guodong Xu <docular.xu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-guodong-xu
+++ a/.mailmap
@@ -325,6 +325,8 @@ Gokul Sriram Palanisamy <quic_gokulsri@q
 Govindaraj Saminathan <quic_gsamin@quicinc.com> <gsamin@codeaurora.org>
 Guo Ren <guoren@kernel.org> <guoren@linux.alibaba.com>
 Guo Ren <guoren@kernel.org> <ren_guo@c-sky.com>
+Guodong Xu <docular.xu@gmail.com> <guodong.xu@linaro.org>
+Guodong Xu <docular.xu@gmail.com> <guodong@riscstar.com>
 Guru Das Srinagesh <linux@gurudas.dev>
 Guru Das Srinagesh <linux@gurudas.dev> <quic_gurus@quicinc.com>
 Guru Das Srinagesh <linux@gurudas.dev> <gurus@codeaurora.org>
_

Patches currently in -mm which might be from docular.xu@gmail.com are

mailmap-add-entries-for-guodong-xu.patch

