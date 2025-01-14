Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CFD2F2E
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 00:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736814983; cv=none; b=HpDqFPjhWsBXAw/Y2Eqoe4JfIZ8HBZeMYC54FICNjGWNEITih/or7VsU7XnMYXTTnjjIlYw49ra8DChwl03GOWsZk9ig0Ej3fX2A2q+VrSddEuPyf7yk0pasBliaw1mNT2xHtnd/PXyoDbo6Yh4E/Ek7fuO8109NhRyCpXH0CBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736814983; c=relaxed/simple;
	bh=nTMSCbiKxmjO8XoDMt19nlwUQ1Adc3YzAGCB3gvyt3U=;
	h=Date:To:From:Subject:Message-Id; b=QeJ1n/5dOjLcpFhYKtQUFKEGnjFAYdl/FGx9WVpV5FTO1RRdIw66RoIW1aNFOco+YSuTchuD9xQ4JjNgHp0nAOmqPxWqYgD36Qoz1HzaacbDaG6qccWBKMjPHgz1aZiqtMTNfe2ZTwJU3+kyZ/0VMSz+I9I7Y9r2IDOgh+IVMho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EthU12sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EthU12sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE7DC4CED6;
	Tue, 14 Jan 2025 00:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736814982;
	bh=nTMSCbiKxmjO8XoDMt19nlwUQ1Adc3YzAGCB3gvyt3U=;
	h=Date:To:From:Subject:From;
	b=EthU12sr1jWBR9n5ZoiRwWTEoAIFG/ofG5VpMLCFodN108BdhM3+GCgvBFxLZlz03
	 sWWHsvozeHz650SDFexNvYxV3LsJ7bqwomtSRLiazIkJ50w0QjhISCHYMM1kWJ6B07
	 b6TICLKo8qarsHyg6SXTH9eOT+qk0qO4NkKTOHwE=
Date: Mon, 13 Jan 2025 16:36:22 -0800
To: mm-commits@vger.kernel.org,ethan@ethancedwards.com,ethancarteredwards@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-ethan-carter-edwards.patch added to mm-hotfixes-unstable branch
Message-Id: <20250114003622.8BE7DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for Ethan Carter Edwards
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-entry-for-ethan-carter-edwards.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-ethan-carter-edwards.patch

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
From: Ethan Carter Edwards <ethancarteredwards@gmail.com>
Subject: mailmap: update entry for Ethan Carter Edwards
Date: Mon, 13 Jan 2025 11:22:22 -0500

Map old gmail + name to my current full name and email.

Link: https://lkml.kernel.org/r/xbfkmvmp4wyxrvlan57bjnul5icrwfyt67vnhhw2cyr5rzbnee@mfvihhd6s7l5
Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-ethan-carter-edwards
+++ a/.mailmap
@@ -203,6 +203,7 @@ Elliot Berman <quic_eberman@quicinc.com>
 Enric Balletbo i Serra <eballetbo@kernel.org> <enric.balletbo@collabora.com>
 Enric Balletbo i Serra <eballetbo@kernel.org> <eballetbo@iseebcn.com>
 Erik Kaneda <erik.kaneda@intel.com> <erik.schmauss@intel.com>
+Ethan Carter Edwards <ethan@ethancedwards.com> Ethan Edwards <ethancarteredwards@gmail.com>
 Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@microchip.com>
 Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@collabora.com>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
_

Patches currently in -mm which might be from ethancarteredwards@gmail.com are

mailmap-update-entry-for-ethan-carter-edwards.patch

