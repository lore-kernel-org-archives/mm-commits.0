Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A122C21C1
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 18:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763490868; cv=none; b=JvnCvCuHWcymYbgKzegODsdBfneeL2FIF8cHFjzGBMnF8wbfgaCdV8v3x0T07fz7aoLmQXdCHqVAoSEciuLpjAKhQ7yt55GpkLQDSGUSI2dOMb5Gyu4qDyvgvfaGAwmTB2prA7gRLatFPg3egIUBNJwvnYVG4NmKyoz8MlE1qwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763490868; c=relaxed/simple;
	bh=Oe/Aevo8hiPPfmKHsgNFkqCEuEHGbEB/xPAV3bThyAw=;
	h=Date:To:From:Subject:Message-Id; b=Dqhr/AV0zFncDCMe8Zd0SoosP1iWxMf3vxdgqifqIcSmXV4JVQDkauAr09zY8vgmKH+Lt4zbJ7OYGMp2v49XUkkVTzHvibKF0O4FimMoxypFcq2EsDo26vzlFDoYi3Devmua5oda19m+TMq+9fRLohWW1tAtwslx4IachzGq+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LTuJiNUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LTuJiNUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E24C19421;
	Tue, 18 Nov 2025 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763490867;
	bh=Oe/Aevo8hiPPfmKHsgNFkqCEuEHGbEB/xPAV3bThyAw=;
	h=Date:To:From:Subject:From;
	b=LTuJiNUvdS9cYQys+6COP2goRlqoI2vZ5yKle7oAzGfXPJugqxXUCjPYydt9sUSGT
	 pNDc6Gl0dkYFeKKqoqeK1MRwVkLuPY3yL662JxR3FQn5W98+b9iYrF9698j+y8/4Jn
	 JA524zUktJ8XKNhWs0AH+CI40mys5AISdIO1LtjU=
Date: Tue, 18 Nov 2025 10:34:25 -0800
To: mm-commits@vger.kernel.org,arnd@arndb.de,semen.protsenko@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-sam-protsenko.patch added to mm-hotfixes-unstable branch
Message-Id: <20251118183427.27E24C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Sam Protsenko
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-sam-protsenko.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-sam-protsenko.patch

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
From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: mailmap: add entry for Sam Protsenko
Date: Mon, 17 Nov 2025 21:31:11 -0600

Use 'Sam Protsenko' as my name consistently in git-shortlog.  Also map my
old GlobalLogic email address to my current email to stay reachable.

Link: https://lkml.kernel.org/r/20251118033111.23382-1-semen.protsenko@linaro.org
Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-sam-protsenko
+++ a/.mailmap
@@ -689,6 +689,8 @@ Sachin Mokashi <sachin.mokashi@intel.com
 Sachin P Sant <ssant@in.ibm.com>
 Sai Prakash Ranjan <quic_saipraka@quicinc.com> <saiprakash.ranjan@codeaurora.org>
 Sakari Ailus <sakari.ailus@linux.intel.com> <sakari.ailus@iki.fi>
+Sam Protsenko <semen.protsenko@linaro.org>
+Sam Protsenko <semen.protsenko@linaro.org> <semen.protsenko@globallogic.com>
 Sam Ravnborg <sam@mars.ravnborg.org>
 Sankeerth Billakanti <quic_sbillaka@quicinc.com> <sbillaka@codeaurora.org>
 Santosh Shilimkar <santosh.shilimkar@oracle.org>
_

Patches currently in -mm which might be from semen.protsenko@linaro.org are

mailmap-add-entry-for-sam-protsenko.patch

