Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3356C194082
	for <mm-commits@vger.kernel.org>; Mon, 30 Sep 2024 21:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727730747; cv=none; b=L3nUDP8t+lStk7BA0rCXTvD0rvlWUjimjxJX41SpJvTQXyuUbA3QKBX0oxu8eDg/JZVnuE3VH1OhbUDkhwwtXZMfPLHwK6lEZJiSKesso7uJnHqcuE5o09OHI1vi6emsMMAjkng+InEqZLaxjTsMXlmjaBvJhv+QHNKjOdKrKy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727730747; c=relaxed/simple;
	bh=NoBb3aqCe6wBOYBXCdMIk8r/Yd4F2lTrRNm8TLuqNvo=;
	h=Date:To:From:Subject:Message-Id; b=u7uSlLsztxQFQnrMbqS4Xo4md6XvCiIgjRpgAfQRda9LhiMfIpZEg2ZKbeNGoj7YANqgv1xuFehW1Vc/1hNF8kI/QRw/5aJ8A/UmrqXaAx+lIBE7wj5tIwbjfAPpf5S4WWkkFCzLEMVTmp0YWmo+c++mDZ4oo1xu+6xgqi+JpwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wEPHJpRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wEPHJpRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A762FC4CEC7;
	Mon, 30 Sep 2024 21:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727730746;
	bh=NoBb3aqCe6wBOYBXCdMIk8r/Yd4F2lTrRNm8TLuqNvo=;
	h=Date:To:From:Subject:From;
	b=wEPHJpRHrF1FE8hN9G30FhnueraZ8PcLP54216rFfhSf0UDYWyXo4paewRQDsNAiX
	 ytKXpTn3HB/ARB3xh/SLA4FxoXnrWGm03G7gLTLDN7X+nLCcWud3WfMncQVTXxdvYs
	 IomlvqND4uK7+FM44lY1u67sKwVkQ5KU8NVRBt3E=
Date: Mon, 30 Sep 2024 14:12:26 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,i@maskray.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-fangruis-email.patch added to mm-hotfixes-unstable branch
Message-Id: <20240930211226.A762FC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .mailmap: update Fangrui's email
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-fangruis-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-fangruis-email.patch

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
From: Fangrui Song <i@maskray.me>
Subject: .mailmap: update Fangrui's email
Date: Fri, 27 Sep 2024 12:29:12 -0700

I'm leaving Google.

Link: https://lkml.kernel.org/r/20240927192912.31532-1-i@maskray.me
Signed-off-by: Fangrui Song <i@maskray.me>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-fangruis-email
+++ a/.mailmap
@@ -203,6 +203,7 @@ Ezequiel Garcia <ezequiel@vanguardiasur.
 Faith Ekstrand <faith.ekstrand@collabora.com> <jason@jlekstrand.net>
 Faith Ekstrand <faith.ekstrand@collabora.com> <jason.ekstrand@intel.com>
 Faith Ekstrand <faith.ekstrand@collabora.com> <jason.ekstrand@collabora.com>
+Fangrui Song <i@maskray.me> <maskray@google.com>
 Felipe W Damasio <felipewd@terra.com.br>
 Felix Kuhling <fxkuehl@gmx.de>
 Felix Moeller <felix@derklecks.de>
_

Patches currently in -mm which might be from i@maskray.me are

mailmap-update-fangruis-email.patch

