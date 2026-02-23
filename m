Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D1A328B69
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 17:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771866800; cv=none; b=gdjoQuo4dCrH2Uknj3nCBkau7w+bNHJg7j4MBUL+8ae3YmcA55T+hBQr+qk8xhTKYwZXi+tj9npMikR3yGyPR/LbfGQF9o1ye7srRSrgJrp8oVdoGNzVh5KD6LIJ4c/QieLgXIgzPJnQeIuIAur24xzW1fd63Al9os399Hq0gy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771866800; c=relaxed/simple;
	bh=Di8IBRpIJM5uvUAVgR+Z6dzmYbHdZJeoEC63fw16n4Q=;
	h=Date:To:From:Subject:Message-Id; b=pgV1VWjJ7NqKjhelWxEKQVsohgkYgOMR+R1ex/+TcLgPyf63ATFtNL/AfjYEnfcqkiFmMoYHy9EXs2scSEdf1GYdPgSvJlLF3B213p5X7ZR+BQunMExWNwx8+DEjF1B6OOcfLntRmVr90FozWYud5o8Pe8SA2KcaWunV/4chRcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wG/Q1m4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wG/Q1m4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBFDC116C6;
	Mon, 23 Feb 2026 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771866800;
	bh=Di8IBRpIJM5uvUAVgR+Z6dzmYbHdZJeoEC63fw16n4Q=;
	h=Date:To:From:Subject:From;
	b=wG/Q1m4FpyzNGjFiXvAToaCqSLEwOt4XWHOOS60+vg0Zr3ZULVw8klZ6s215g5J/S
	 wCOzGDSTkEkPogxaROZ57NrWt/WKFca8msiuHIcuJGJW8kufuVUtCOCceZd+3TZwrw
	 BR8KudArrIfIvEYlSbTR0qTyzZfKNl9APCztHmJo=
Date: Mon, 23 Feb 2026 09:13:19 -0800
To: mm-commits@vger.kernel.org,daniele.alessandrelli@gmail.com,daniele.alessandrelli@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-daniele-alessandrelli.patch added to mm-hotfixes-unstable branch
Message-Id: <20260223171320.3EBFDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Daniele Alessandrelli
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-daniele-alessandrelli.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-daniele-alessandrelli.patch

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
From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: mailmap: add entry for Daniele Alessandrelli
Date: Mon, 23 Feb 2026 17:09:05 +0000

My Intel email is going to bounce soon.  Map it to my personal Gmail
address.

Link: https://lkml.kernel.org/r/20260223170905.278956-1-daniele.alessandrelli@intel.com
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Cc: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-daniele-alessandrelli
+++ a/.mailmap
@@ -211,6 +211,7 @@ Daniel Borkmann <daniel@iogearbox.net> <
 Daniel Borkmann <daniel@iogearbox.net> <dborkman@redhat.com>
 Daniel Borkmann <daniel@iogearbox.net> <dxchgb@gmail.com>
 Daniel Thompson <danielt@kernel.org> <daniel.thompson@linaro.org>
+Daniele Alessandrelli <daniele.alessandrelli@gmail.com> <daniele.alessandrelli@intel.com>
 Danilo Krummrich <dakr@kernel.org> <dakr@redhat.com>
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
_

Patches currently in -mm which might be from daniele.alessandrelli@intel.com are

mailmap-add-entry-for-daniele-alessandrelli.patch

