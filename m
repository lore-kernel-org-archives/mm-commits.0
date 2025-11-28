Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4ED2AD3D
	for <mm-commits@vger.kernel.org>; Fri, 28 Nov 2025 18:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764356309; cv=none; b=W/Y0UtrSMeEVoC8Il+Joyysdx4xM10tt10mUyzBK1Xc12yqxxlnamfkkMqJUhhhqipn4L3q4YC3GBpVAHMyog8gXGMJ7CWKqIJQmPoUWI66ws0YXcj7iC0OEn44Z2AFNSL5tW3iGl2ybpIhddHuQ2c1DdzWm/8PHoL6GJYuRH70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764356309; c=relaxed/simple;
	bh=DHjGOVQguGktf5pNTgpAEfpY1rPH3vpxA3UPQNAWQS8=;
	h=Date:To:From:Subject:Message-Id; b=NAXDAEHa26D4DE6LQx97uUKDO3mgupnZDj1ossH6bpehCpIzsm/onNW3ql4A/UzRQ+29XotB0r+8u5Mpz88+V7BSB0P/KTK2FaZ+/BacL9uaCPacvs93Gm/w0r8o5xLsQxmREZqI2HPP0xaExOCWY6lyjIoSHqAKY6jLNidzUto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ni0PHjzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ni0PHjzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1787DC4CEF1;
	Fri, 28 Nov 2025 18:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764356309;
	bh=DHjGOVQguGktf5pNTgpAEfpY1rPH3vpxA3UPQNAWQS8=;
	h=Date:To:From:Subject:From;
	b=ni0PHjziKQY7TzrS/QZEB+Mz32vwm7jysyWC+8CeqGaz2kDc2WU8GVmrwTFRNTxEg
	 X2LS/6gpclFlb8w5wx+Ta5SffN2NkdhPDfrpQY55LJ/LOHlC00eHfJClas9qblc1Vr
	 5z6HqBN2KXwKsmdqqRhh/CX0ARRvl7oVLG8UdOTQ=
Date: Fri, 28 Nov 2025 10:58:28 -0800
To: mm-commits@vger.kernel.org,hverkuil@kernel.org,brgl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-bartosz-golaszewski.patch added to mm-hotfixes-unstable branch
Message-Id: <20251128185829.1787DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for Bartosz Golaszewski
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-entry-for-bartosz-golaszewski.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-bartosz-golaszewski.patch

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
From: Bartosz Golaszewski <brgl@kernel.org>
Subject: mailmap: update entry for Bartosz Golaszewski
Date: Fri, 28 Nov 2025 14:33:18 +0100

My linaro address will stop working tonight. Update my mailmap entry.

Link: https://lkml.kernel.org/r/20251128133318.44912-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <brgl@kernel.org>
Cc: Hans Verkuil <hverkuil@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-entry-for-bartosz-golaszewski
+++ a/.mailmap
@@ -127,7 +127,8 @@ Barry Song <baohua@kernel.org> <Baohua.S
 Barry Song <baohua@kernel.org> <barry.song@analog.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
-Bartosz Golaszewski <brgl@bgdev.pl> <bgolaszewski@baylibre.com>
+Bartosz Golaszewski <brgl@kernel.org> <bartosz.golaszewski@linaro.org>
+Bartosz Golaszewski <brgl@kernel.org> <bgolaszewski@baylibre.com>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@simtec.co.uk>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@sifive.com>
 Ben Gardner <bgardner@wabtec.com>
_

Patches currently in -mm which might be from brgl@kernel.org are

mailmap-update-entry-for-bartosz-golaszewski.patch

