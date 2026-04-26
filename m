Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7B62D5926
	for <mm-commits@vger.kernel.org>; Sun, 26 Apr 2026 09:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777196515; cv=none; b=V8HV33CxO1vlq2//MYXBsy417jv55Fuir2gSuedF7uPTau8KK+YHZOSU0OnFZqS+OKNqhG2dJmSWg0Lh4pQnigZaoq7zauouvJAaXw5LtVRrvBIIsYHhh5jJwj9w/+HIb7oL/SJ8j0O4qXOo/PXShGnyTqwodjsR71bvSutZFDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777196515; c=relaxed/simple;
	bh=UdvgFZJD8PoTG4Rufj2jvaHwbP1AD+I8/XdtB7pL1R8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pTTdawwmr0hv8PEEBr5ar5oKYCzY7zq8xnhrEjjCdX4jc7VUrPlZ7/CIY9+mmn3z65uD9JmN1eEPprL6CsCUuQuXC5JzqdXsF1PKhF3tJm+iKbg5D0TX2Kz0zFIL/Rfe48WzI8yxen69/1rmGry6/DClTpVxLq2/U16AbudlcL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DE31C1E62;
	Sun, 26 Apr 2026 09:41:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id 6D7EA20029;
	Sun, 26 Apr 2026 09:41:45 +0000 (UTC)
Message-ID: <f19f6eacedde4fbd10a0d096e120ee8694d16fcd.camel@perches.com>
Subject: Re: + get_maintainer-add-json-output-mode.patch added to
 mm-nonmm-unstable branch
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	sashal@kernel.org
Date: Sun, 26 Apr 2026 02:41:44 -0700
In-Reply-To: <20260424181430.E5FC3C2BCB0@smtp.kernel.org>
References: <20260424181430.E5FC3C2BCB0@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 6D7EA20029
X-Stat-Signature: pcqgb46sydpintmouz31hcdh6ydmsrmf
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18WcEZRioDGVY4GEGUwKT8CZn0hplz5hm4=
X-HE-Tag: 1777196505-741435
X-HE-Meta: U2FsdGVkX19YTbzYueFbNv4c9jGazkBwTMtri1mkUQqF46vkh5PzjkwMelbGaobMThZQB2lUOB5jchdMpNmh+IIzj0Gdo9k1MC/SGb7bZ8xw5Idgaq1XHWurkPuiX6Fnr1b6p1NKDjmAbexIm0lrptuYJeXCfnMX7/BZvyL5hioaSlux4lXpRXVzFlryid7UrC9KlcnitJKamMlsFkf7VWrOjQx9xDtzcJ60U9OwFrdPI+ffzysCZYdlE5BbJaz+wOCAIYUZD8U9qFtLYtihzxLMZ0wAem0+o5mvjAmMmE2ogpNcOnoaRTVazWwQwJ+9f+ZlLs6KR9TJkacFArruIL3jwNrE8yUE

On Fri, 2026-04-24 at 11:14 -0700, Andrew Morton wrote:
> The patch titled
>      Subject: get_maintainer: add --json output mode
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      get_maintainer-add-json-output-mode.patch
>=20
> This patch will shortly appear at
>      [https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tre=
e/patches/get_maintainer-add-json-output-mode.patch](https://git.kernel.org=
/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainer-add-j=
son-output-mode.patch)

There might be another patch version to replace this soonish.

https://lore.kernel.org/lkml/ae1XUFURKgdG6lGh@laps/

Still uncertain as to the --json vs --json-pretty option.
