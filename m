Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F41A22F01
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 15:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739891128; cv=none; b=l77TRzoi/cuQInkbcIS+Jn6R+kt6YReO24RmJLLTAP5aJ/wm9eELnwEpllu3BPyIlCNCRRscjoHVud3jU1NT3VjiAMoQyDObjKVpUOmxqDolhAmW1waTtYtlYxZ+tTmG2xDIEwxna5w8BW8ZXU3hNP31y+UsnqGLUbD4VZhTyYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739891128; c=relaxed/simple;
	bh=J23R0SjOvWeKfOYp3pPpwO7KcOZHlEJThPzdslc15Ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J1EwR8vazZPqzepJpTCR9k6MkPFCFKvcE3eXoUiTkK1o8t2rZdIyn4CI/t21YOUCkJ1x+muybIdriyRfXsjU/JNq2Ja5DiO/TOMan4qIRfdwwP80UOmfobbw2guTFbn3QWnvH6nj6JjW/PtnVvzqyUqDcOkY/m2uaaO3lpXX1/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajSLrBe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajSLrBe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1A9C4CEE2;
	Tue, 18 Feb 2025 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739891128;
	bh=J23R0SjOvWeKfOYp3pPpwO7KcOZHlEJThPzdslc15Ws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ajSLrBe5er2VkIEczmbjiZZGOvxCq9smxuRdXf9DotIL1+or9Q4iA1VkkjdpOy75a
	 5+/1ntMvGFXqSSzC6Qa2/vrgxk7WqISgU2AuCG8oTZCUleEf92N7L7s2pFZZn5v5Bm
	 A9uQnyWzAkrLoNf+lu4d16iIf5qUvh1ZfY8hcSfTh2WtX0wVNras2eQfiosqpBfuiL
	 YGf5K0xOqCmCWtTuDJnyvxwFMH6rnCKoN5AhBFQr5qCpdjKnGs+bFRYT4CEPnHmbM2
	 tSYH0qaFrUgXMNk7beDiAU4tN+oJkzoY9+De15nSWGGu8D7X67F+IbnxJP3JBz0Gie
	 T3rC3o4gTKBNg==
Date: Tue, 18 Feb 2025 15:05:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tzungbi@kernel.org, teknoraver@meta.com,
	serge@hallyn.com, rui.zhang@intel.com, robh@kernel.org,
	rafael@kernel.org, mazziesaccount@gmail.com, lukasz.luba@arm.com,
	lgirdwood@gmail.com, kernel@pengutronix.de, groeck@chromium.org,
	festevam@denx.de, daniel.lezcano@linaro.org, corbet@lwn.net,
	bleung@chromium.org, a.fatoum@pengutronix.de
Subject: Re: +
 regulator-allow-user-configuration-of-hardware-protection-action.patch added
 to mm-nonmm-unstable branch
Message-ID: <Z7ShszudrCbadXuL@finisterre.sirena.org.uk>
References: <20250218025407.51C9FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7Gl7LWGrXpkQo3zz"
Content-Disposition: inline
In-Reply-To: <20250218025407.51C9FC4CED1@smtp.kernel.org>
X-Cookie: Editing is a rewording activity.


--7Gl7LWGrXpkQo3zz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 06:54:06PM -0800, Andrew Morton wrote:
>=20
> The patch titled
>      Subject: regulator: allow user configuration of hardware protection =
action
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      regulator-allow-user-configuration-of-hardware-protection-action.pat=
ch

This patch was posted less than 24 hours ago, after I last looked at my
mail yesterday.  There's not been *any* chance for review here, I'm
still triaging my inbox today.

--7Gl7LWGrXpkQo3zz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme0obMACgkQJNaLcl1U
h9CFzwf8CHXMirNEsf2mdM7nAbSvI77uKkOCVp120bDeviwmF3xrG35tuS2w7X9v
UCXosSLfsT9Elb0cQ2m6cnJccUJDfMmKcA7yRqGofL6dV+a7jB3Pim/FJKTuKFkL
UbFtmbW4a28InIP9Mff5IIEUaZnlJb70+/HZmeuPC6A5d1GVyioja/LAYZesfb+L
A6J0oUTYM22uj6ypWsGvl78CwsMCD4yIXWxmJqBel8f6DIRW0QKzP7Na/zvKwUbb
rVdkXs/ijPrqQKWGwdvXkuqKD1Nd5Xl8nUdpcoXfYjS1XIlFj9QyuxK/i0/ck8lq
jP4bxwUoV0Z0+BBHL+V7bwoP4d9C8w==
=z51T
-----END PGP SIGNATURE-----

--7Gl7LWGrXpkQo3zz--
